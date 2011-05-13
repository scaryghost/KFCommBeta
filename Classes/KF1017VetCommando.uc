class KF1017VetCommando extends SRVeterancyTypes
    abstract;

struct perkProgress {
    var int stalkerKills;
    var int damPoints;
};

var int maxStockLevel;
var array<perkProgress> perkProgressArray;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum ) {
    if (CurLevel > default.maxStockLevel) {
        if (ReqNum == 0) {
            FinalInt = 3600+GetDoubleScaling(CurLevel,350);
        } else {
            FinalInt = 5500000+GetDoubleScaling(CurLevel,500000);
        }
    } else {
        if (ReqNum == 0) {
           FinalInt= default.PerkProgressArray[CurLevel].stalkerKills;
        } else {
           FinalInt= default.PerkProgressArray[CurLevel].damPoints;
        }
    }

    if( ReqNum==0 )
        return Min(StatOther.RStalkerKillsStat,FinalInt);
    return Min(StatOther.RBullpupDamageStat,FinalInt);
}

// Display enemy health bars
static function SpecialHUDInfo(KFPlayerReplicationInfo KFPRI, Canvas C) {
    local KFMonster KFEnemy;
    local HUDKillingFloor HKF;
    local float MaxDistanceSquared;

    if ( KFPRI.ClientVeteranSkillLevel > 0 ) {
        HKF = HUDKillingFloor(C.ViewPort.Actor.myHUD);
        if ( HKF == none || C.ViewPort.Actor.Pawn == none )
            return;

        switch ( KFPRI.ClientVeteranSkillLevel ) {
            case 1:
                MaxDistanceSquared = 25600; // 20% (160 units)
                break;
            case 2:
                MaxDistanceSquared = 102400; // 40% (320 units)
                break;
            case 3:
                MaxDistanceSquared = 230400; // 60% (480 units)
                break;
            case 4:
                MaxDistanceSquared = 409600; // 80% (640 units)
                break;
            default:
                MaxDistanceSquared = 640000; // 100% (800 units)
                break;
        }

        foreach C.ViewPort.Actor.DynamicActors(class'KFMonster',KFEnemy) {
            if ( KFEnemy.Health > 0 && !KFEnemy.Cloaked() && VSizeSquared(KFEnemy.Location - C.ViewPort.Actor.Pawn.Location) < MaxDistanceSquared )
                HKF.DrawHealthBar(C, KFEnemy, KFEnemy.Health, KFEnemy.HealthMax , 50.0);
        }
    }
}

static function bool ShowStalkers(KFPlayerReplicationInfo KFPRI) {
    return true;
}

static function float GetStalkerViewDistanceMulti(KFPlayerReplicationInfo KFPRI) {
    switch ( KFPRI.ClientVeteranSkillLevel ) {
        case 0:
            return 0.0625; // 25%
        case 1:
            return 0.25; // 50%
        case 2:
            return 0.36; // 60%
        case 3:
            return 0.49; // 70%
        case 4:
            return 0.64; // 80%
    }

    return 1.0; // 100% of Standard Distance(800 units or 16 meters)
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
    if ( (Bullpup(Other) != none || AK47AssaultRifle(Other) != none || SCARMK17AssaultRifle(Other) != none ) && KFPRI.ClientVeteranSkillLevel > 0 ) {
        if ( KFPRI.ClientVeteranSkillLevel == 1 )
            return 1.10;
        else if ( KFPRI.ClientVeteranSkillLevel == 2 )
            return 1.20;
        return 1.25; // 25% increase in assault rifle ammo carry
    }
    return 1.0;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other) {
    if ( (BullpupAmmo(Other) != none || AK47Ammo(Other) != none || SCARMK17Ammo(Other) != none) && KFPRI.ClientVeteranSkillLevel > 0 ) {
        if ( KFPRI.ClientVeteranSkillLevel == 1 )
            return 1.10;
        else if ( KFPRI.ClientVeteranSkillLevel == 2 )
            return 1.20;
        return 1.25; // 25% increase in assault rifle ammo carry
    }
    return 1.0;
}
static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType) {
    if ( (AmmoType == class'BullpupAmmo' || AmmoType == class'AK47Ammo' || AmmoType == class'SCARMK17Ammo') && KFPRI.ClientVeteranSkillLevel > 0 ) {
        if ( KFPRI.ClientVeteranSkillLevel == 1 )
            return 1.10;
        else if ( KFPRI.ClientVeteranSkillLevel == 2 )
            return 1.20;
        return 1.25; // 25% increase in assault rifle ammo carry
    }
    return 1.0;
}
static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType) {
    if ( DmgType == class'DamTypeBullpup' || DmgType == class'DamTypeAK47AssaultRifle' || DmgType == class'DamTypeSCARMK17AssaultRifle' ) {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return float(InDamage) * 1.05;
        return float(InDamage) * (1.00 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)))); // Up to 50% increase in Damage with Bullpup
    }
    return InDamage;
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil) {
    if ( Bullpup(Other.Weapon) != none || AK47AssaultRifle(Other.Weapon) != none || SCARMK17AssaultRifle(Other.Weapon) != none ) {
        if ( KFPRI.ClientVeteranSkillLevel <= 3 )
            Recoil = 0.95 - (0.05 * float(KFPRI.ClientVeteranSkillLevel));
        else if ( KFPRI.ClientVeteranSkillLevel <= 5 )
            Recoil = 0.70;
        else
            Recoil = 0.60; // Level 6 - 40% recoil reduction
        return Recoil;
    }
    Recoil = 1.0;
    return Recoil;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    return 1.05 + (0.05 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel))); // Up to 35% faster reload speed
}

// Set number times Zed Time can be extended
static function int ZedTimeExtensions(KFPlayerReplicationInfo KFPRI) {
    if ( KFPRI.ClientVeteranSkillLevel >= 3 )
        return min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel) - 2; // Up to 4 Zed Time Extensions
    return 0;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'BullpupPickup' || Item == class'AK47Pickup' || Item == class'SCARMK17Pickup' )
        return FMax(0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)),0.3f); // Up to 70% discount on Assault Rifles
    return 1.0;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5, give them Bullpup
    if ( KFPRI.ClientVeteranSkillLevel == 5 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Bullpup", GetCostScaling(KFPRI, class'BullpupPickup'));
    // If Level 6, give them an AK47
    if ( KFPRI.ClientVeteranSkillLevel >= default.maxStockLevel )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.AK47AssaultRifle", GetCostScaling(KFPRI, class'AK47Pickup'));
}

static function string GetCustomLevelInfo( byte Level ) {
    return default.LevelEffects[6];
}

defaultproperties {
    maxStockLevel= 6

    PerkIndex=3

    OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Commando'
    OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Commando_Gold'
    VeterancyName="1017Commando"
    Requirements[0]="Kill %x Stalkers with Bullpup/AK47/SCAR"
    Requirements[1]="Deal %x damage with Bullpup/AK47/SCAR"
    NumRequirements=2

    PerkProgressArray(0)= (stalkerKills=10,damPoints=10000)
    PerkProgressArray(1)= (stalkerKills=30,damPoints=25000)
    PerkProgressArray(2)= (stalkerKills=100,damPoints=100000)
    PerkProgressArray(3)= (stalkerKills=350,damPoints=500000)
    PerkProgressArray(4)= (stalkerKills=1200,damPoints=1500000)
    PerkProgressArray(5)= (stalkerKills=2400,damPoints=3500000)
    PerkProgressArray(6)= (stalkerKills=3600,damPoints=5500000)


    LevelEffects(0)="5% more damage with Bullpup/AK47/SCAR|5% less recoil with Bullpup/AK47/SCAR|5% faster reload with all weapons|10% discount on Bullpup/AK47/SCAR|Can see cloaked Stalkers from 4 meters"
    LevelEffects(1)="10% more damage with Bullpup/AK47/SCAR|10% less recoil with Bullpup/AK47/SCAR|10% larger Bullpup/AK47/SCAR clip|10% faster reload with all weapons|20% discount on Bullpup/AK47/SCAR|Can see cloaked Stalkers from 8m|Can see enemy health from 4m"
    LevelEffects(2)="20% more damage with Bullpup/AK47/SCAR|15% less recoil with Bullpup/AK47/SCAR|20% larger Bullpup/AK47/SCAR clip|15% faster reload with all weapons|30% discount on Bullpup/AK47/SCAR|Can see cloaked Stalkers from 10m|Can see enemy health from 7m"
    LevelEffects(3)="30% more damage with Bullpup/AK47/SCAR|20% less recoil with Bullpup/AK47/SCAR|25% larger Bullpup/AK47/SCAR clip|20% faster reload with all weapons|40% discount on Bullpup/AK47/SCAR|Can see cloaked Stalkers from 12m|Can see enemy health from 10m|Zed-Time can be extended by killing an enemy while in slow motion"
    LevelEffects(4)="40% more damage with Bullpup/AK47/SCAR|30% less recoil with Bullpup/AK47/SCAR|25% larger Bullpup/AK47/SCAR clip|25% faster reload with all weapons|50% discount on Bullpup/AK47/SCAR|Can see cloaked Stalkers from 14m|Can see enemy health from 13m|Up to 2 Zed-Time Extensions"
    LevelEffects(5)="50% more damage with Bullpup/AK47/SCAR|30% less recoil with Bullpup/AK47/SCAR|25% larger Bullpup/AK47/SCAR clip|30% faster reload with all weapons|60% discount on Bullpup/AK47/SCAR|Spawn with a Bullpup|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 3 Zed-Time Extensions"
    LevelEffects(6)="50% more damage with Bullpup/AK47/SCAR|40% less recoil with Bullpup/AK47/SCAR|25% larger Bullpup/AK47/SCAR clip|35% faster reload with all weapons|70% discount on Bullpup/AK47/SCAR|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
//    CustomLevelInfo="50% more damage with Bullpup/AK47/SCAR|%r less recoil with Bullpup/AK47/SCAR|25% larger Bullpup/AK47/SCAR clip|%s faster reload with all weapons|%d discount on Bullpup/AK47/SCAR|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to %z Zed-Time Extensions"
}
