class KF1017VetSupport extends SRVeterancyTypes
    abstract;

struct perkProgress {
    var int weldPoints;
    var int damPoints;
};

var int maxStockLevel;
var array<perkProgress> PerkProgressArray;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum ) {
    if (CurLevel > default.maxStockLevel) {
        if (ReqNum == 0) {
            FinalInt = 370000+GetDoubleScaling(CurLevel,35000);
        } else {
            FinalInt = 5500000+GetDoubleScaling(CurLevel,500000);
        }
    } else {
        if (ReqNum == 0) {
           FinalInt= default.PerkProgressArray[CurLevel].weldPoints;
        } else {
           FinalInt= default.PerkProgressArray[CurLevel].damPoints;
        }
    }

    if( ReqNum==0 )
        return Min(StatOther.RWeldingPointsStat,FinalInt);
    return Min(StatOther.RShotgunDamageStat,FinalInt);
}

static function int AddCarryMaxWeight(KFPlayerReplicationInfo KFPRI) {
    if ( KFPRI.ClientVeteranSkillLevel == 0 )
        return 0;
    else if ( KFPRI.ClientVeteranSkillLevel <= 4 )
        return 1 + KFPRI.ClientVeteranSkillLevel;
    else if ( KFPRI.ClientVeteranSkillLevel == 5 )
        return 8; // 8 more carry slots
    return 9; // 9 more carry slots
}

static function float GetWeldSpeedModifier(KFPlayerReplicationInfo KFPRI) {
    if ( KFPRI.ClientVeteranSkillLevel <= 3 )
        return 1.0 + (0.25 * float(KFPRI.ClientVeteranSkillLevel));
    return 2.5; // 150% increase in speed
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType) {
    if ( AmmoType == class'FragAmmo' )
        // Up to 6 extra Grenades
        return 1.0 + (0.20 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel)));
    else if ( AmmoType == class'ShotgunAmmo' || AmmoType == class'DBShotgunAmmo' || AmmoType == class'AA12Ammo' ) {
        if ( KFPRI.ClientVeteranSkillLevel > 0 ) {
            if ( KFPRI.ClientVeteranSkillLevel == 1 )
                return 1.10;
            else if ( KFPRI.ClientVeteranSkillLevel == 2 )
                return 1.20;
            else if ( KFPRI.ClientVeteranSkillLevel >= 6 )
                return 1.30; // Level 6 - 30% increase in shotgun ammo carried
            return 1.25; // 25% increase in shotgun ammo carried
        }
    }
    return 1.0;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType) {
    if ( DmgType == class'DamTypeShotgun' || DmgType == class'DamTypeDBShotgun' || DmgType == class'DamTypeAA12Shotgun' ) {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return float(InDamage) * 1.10;
        return InDamage * (1.00 + (0.10 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel)))); // Up to 60% more damage with Shotguns
    }
    else if ( DmgType == class'DamTypeFrag' && KFPRI.ClientVeteranSkillLevel > 0 ) {
        if ( KFPRI.ClientVeteranSkillLevel == 1 )
            return float(InDamage) * 1.05;
        return float(InDamage) * (0.90 + (0.10 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel)))); // Up to 50% more damage with Nades
    }
    return InDamage;
}

// Reduce Penetration damage with Shotgun slower
static function float GetShotgunPenetrationDamageMulti(KFPlayerReplicationInfo KFPRI) {
    if ( KFPRI.ClientVeteranSkillLevel == 0 )
        return class'ShotgunBullet'.default.PenDamageReduction + (class'ShotgunBullet'.default.PenDamageReduction / 10.0);
    return class'ShotgunBullet'.default.PenDamageReduction + ((class'ShotgunBullet'.default.PenDamageReduction / 5.5555) * float(Min(KFPRI.ClientVeteranSkillLevel, 5)));
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'ShotgunPickup' || Item == class'BoomstickPickup' || Item == class'AA12Pickup')
        return FMax(0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)),0.3f); // Up to 70% discount on Shotguns
    return 1.0;
}

// Give Extra Items as Default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5, give them Assault Shotgun
    if ( KFPRI.ClientVeteranSkillLevel == 5 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Shotgun", GetCostScaling(KFPRI, class'ShotgunPickup'));
    // If Level 6, give them Hunting Shotgun
    if ( KFPRI.ClientVeteranSkillLevel >= 6 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.BoomStick", GetCostScaling(KFPRI, class'BoomStickPickup'));
}

static function string GetCustomLevelInfo( byte Level ) {
    return default.LevelEffects[6];
}

defaultproperties {
    PerkIndex=1

    OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Support'
    OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Support_Gold'
    VeterancyName="1017Support"
    Requirements[0]="Weld %x door hitpoints"
    Requirements[1]="Deal %x damage with shotguns"
    NumRequirements=2

    maxStockLevel= 6;

    PerkProgressArray(0)= (weldPoints=1000,damPoints=1000)
    PerkProgressArray(1)= (weldPoints=2000,damPoints=5000)
    PerkProgressArray(2)= (weldPoints=7000,damPoints=100000)
    PerkProgressArray(3)= (weldPoints=35000,damPoints=500000)
    PerkProgressArray(4)= (weldPoints=120000,damPoints=1500000)
    PerkProgressArray(5)= (weldPoints=250000,damPoints=3500000)
    PerkProgressArray(6)= (weldPoints=370000,damPoints=5500000)

	LevelEffects(0)="10% more damage with Shotguns|10% better Shotgun penetration|10% faster welding/unwelding|10% discount on Shotguns"
	LevelEffects(1)="10% more damage with Shotguns|18% better Shotgun penetration|10% extra shotgun ammo|5% more damage with Grenades|20% increase in grenade capacity|15% increased carry weight|25% faster welding/unwelding|20% discount on Shotguns"
	LevelEffects(2)="20% more damage with Shotguns|36% better Shotgun penetration|20% extra shotgun ammo|10% more damage with Grenades|40% increase in grenade capacity|20% increased carry weight|50% faster welding/unwelding|30% discount on Shotguns"
	LevelEffects(3)="30% more damage with Shotguns|54% better Shotgun penetration|25% extra shotgun ammo|20% more damage with Grenades|60% increase in grenade capacity|25% increased carry weight|75% faster welding/unwelding|40% discount on Shotguns"
	LevelEffects(4)="40% more damage with Shotguns|72% better Shotgun penetration|25% extra shotgun ammo|30% more damage with Grenades|80% increase in grenade capacity|30% increased carry weight|100% faster welding/unwelding|50% discount on Shotguns"
	LevelEffects(5)="50% more damage with Shotguns|90% better Shotgun penetration|25% extra shotgun ammo|40% more damage with Grenades|100% increase in grenade capacity|50% increased carry weight|150% faster welding/unwelding|60% discount on Shotguns|Spawn with a Shotgun"
	LevelEffects(6)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
//	CustomLevelInfo="%s more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|%g more damage with Grenades|120% increase in grenade capacity|%s increased carry weight|150% faster welding/unwelding|%d discount on Shotguns|Spawn with a Hunting Shotgun"

}
