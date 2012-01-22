class KF1017VetFirebug extends SRVeterancyTypes
    abstract;

var int maxStockLevel;
var array<int> PerkProgressArray;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum ) {
    if (CurLevel <= default.maxStockLevel) {
        FinalInt= default.PerkProgressArray[CurLevel];
    } else {
        FinalInt = 5500000+GetDoubleScaling(CurLevel,500000);
    }

    return Min(StatOther.RMeleeDamageStat,FinalInt);
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    if ( Flamethrower(Other) != none && KFPRI.ClientVeteranSkillLevel > 0 )
        return 1.0 + (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 60% larger fuel canister
    if ( MAC10MP(Other) != none && KFPRI.ClientVeteranSkillLevel > 0 )
        return 1.0 + (0.12 * FMin(float(KFPRI.ClientVeteranSkillLevel), 5.0)); // 60% increase in MAC10 ammo carry
    return 1.0;
}
static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other) {
    if ( FlameAmmo(Other) != none && KFPRI.ClientVeteranSkillLevel > 0 )
        return 1.0 + (0.10 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel))); // Up to 60% larger fuel canister
    return 1.0;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType) {
    if ( AmmoType == class'FlameAmmo' && KFPRI.ClientVeteranSkillLevel > 0 )
        return 1.0 + (0.10 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel))); // Up to 60% larger fuel canister
    return 1.0;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType) {
    if ( class<DamTypeBurned>(DmgType) != none || class<DamTypeFlamethrower>(DmgType) != none ) {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return float(InDamage) * 1.05;
        return float(InDamage) * (1.0 + (0.10 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel)))); //  Up to 60% extra damage
    }
    return InDamage;
}

// Change effective range on FlameThrower
static function int ExtraRange(KFPlayerReplicationInfo KFPRI) {
    if ( KFPRI.ClientVeteranSkillLevel <= 2 )
        return 0;
    else if ( KFPRI.ClientVeteranSkillLevel <= 4 )
        return 1; // 50% Longer Range
    return 2; // 100% Longer Range
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster DamageTaker, int InDamage, class<DamageType> DmgType) {
    if ( class<DamTypeBurned>(DmgType) != none || class<DamTypeFlamethrower>(DmgType) != none )
    {
        if ( KFPRI.ClientVeteranSkillLevel <= 3 )
            return float(InDamage) * (0.50 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)));
        return 0; // 100% reduction in damage from fire
    }
    return InDamage;
}

static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI) {
    if ( KFPRI.ClientVeteranSkillLevel >= 3 )
        return class'FlameNade'; // Grenade detonations cause enemies to catch fire
    return super.GetNadeType(KFPRI);
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    if ( Flamethrower(Other) != none ) {
        return 1.0 + (0.10 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel))); // Up to 60% faster reload with Flamethrower
    }
    if ( MAC10MP(Other) != none ) {
        return 1.0 + (0.05 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel))); // Up to 30% faster reload with MAC-10
    }
    return 1.0;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'FlameThrowerPickup' || Item == class'MAC10Pickup' )
        return FMax(0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)),0.3f); // Up to 70% discount on Flame Thrower
    return 1.0;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5, give them a Flame Thrower
    if ( KFPRI.ClientVeteranSkillLevel == 5 ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.FlameThrower", GetCostScaling(KFPRI, class'FlamethrowerPickup'));
    }
    // If Level 6, give them Mac10 and Body Armor
    else if ( KFPRI.ClientVeteranSkillLevel >= default.maxStockLevel ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.MAC10MP", GetCostScaling(KFPRI, class'MAC10Pickup'));
        P.ShieldStrength = 100;
    }
}

static function class<DamageType> GetMAC10DamageType(KFPlayerReplicationInfo KFPRI) {
    return class'DamTypeMAC10MPInc';
}

static function string GetCustomLevelInfo( byte Level ) {
    return default.LevelEffects[6];
}

defaultproperties {
     maxStockLevel=6

     PerkIndex=5
     OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Firebug'
     OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Firebug_Gold'
     VeterancyName="1017Firebug"

     PerkProgressArray(0)=5000
     PerkProgressArray(1)=25000
     PerkProgressArray(2)=100000
     PerkProgressArray(3)=500000
     PerkProgressArray(4)=1500000
     PerkProgressArray(5)=3500000
     PerkProgressArray(6)=5500000

     Requirements(0)="Deal %x damage with the Flamethrower"

     LevelEffects(0)="5% extra Flamethrower/Mac10 damage|50% resistance to fire|10% discount on the Flamethrower/Mac10"

     LevelEffects(1)="10% extra Flamethrower/Mac10 damage|10% faster Flamethrower reload|5% faster Mac10 reload|10% larger fuel canister|12% larger Mac10 clip|60% resistance to fire|20% discount on the Flamethrower/Mac10"
     LevelEffects(2)="20% extra Flamethrower/Mac10 damage|20% faster Flamethrower reload|10% faster Mac10 reload|20% larger fuel canister|24% larger Mac10 clip|70% resistance to fire|30% discount on the Flamethrower/Mac10"
     LevelEffects(3)="30% extra Flamethrower/Mac10 damage|30% faster Flamethrower reload|15% faster Mac10 reload|30% larger fuel canister|36% larger Mac10 clip|80% resistance to fire|50% extra Flamethrower range|Grenades set enemies on fire|40% discount on the Flamethrower/Mac10"
     LevelEffects(4)="40% extra Flamethrower/Mac10 damage|40% faster Flamethrower reload|20% faster Mac10 reload|40% larger fuel canister|48% larger Mac10 clip|90% resistance to fire|50% extra Flamethrower range|Grenades set enemies on fire|50% discount on the Flamethrower/Mac10"
     LevelEffects(5)="50% extra Flamethrower/Mac10 damage|50% faster Flamethrower reload|25% faster Mac10 reload|50% larger fuel canister|60% larger Mac10 clip|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|60% discount on the FlameThrower/Mac10|Spawn with a Flamethrower"
     LevelEffects(6)="60% extra Flamethrower/Mac10 damage|60% faster Flamethrower reload|30% faster Mac10 reload|60% larger fuel canister|60% larger Mac10 clip|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on the FlameThrower/Mac10|Spawn with a Mac10 and Body Armor"
     CustomLevelInfo="%s extra Flamethrower/Mac10 damage|%s faster Flamethrower reload|%m faster Mac10 reload|%s larger fuel canister|%s larger Mac10 clip|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|%d discount on the FlameThrower/Mac10|Spawn with a Mac10 and Body Armor"
}
