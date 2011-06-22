class KF1017VetDemolitions extends SRVeterancyTypes
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

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType) {
    if ( AmmoType == class'FragAmmo'  ) {
        // Up to 6 extra Grenades
        return 1.0 + (0.20 * float(KFPRI.ClientVeteranSkillLevel));
    }
    else if ( AmmoType == class'PipeBombAmmo' ) {
        // Up to 6 extra for a total of 8 Remote Explosive Devices
        return 1.0 + (0.5 * float(KFPRI.ClientVeteranSkillLevel));
    }
    else if ( AmmoType == class'LAWAmmo' ) {
        // Modified in Balance Round 5 to be up to 100% extra ammo
        return 1.0 + (0.20 * float(KFPRI.ClientVeteranSkillLevel));
    }

    return 1.0;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType) {
    if ( class<DamTypeFrag>(DmgType) != none || class<DamTypePipeBomb>(DmgType) != none ||
         class<DamTypeM79Grenade>(DmgType) != none || class<DamTypeM32Grenade>(DmgType) != none ||
         class<DamTypeRocketImpact>(DmgType) != none )
    {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return float(InDamage) * 1.05;
        return float(InDamage) * (1.0 + (0.10 * float(KFPRI.ClientVeteranSkillLevel))); //  Up to 60% extra damage
    }

    return InDamage;
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster DamageTaker, int InDamage, class<DamageType> DmgType) {
    if ( class<DamTypeFrag>(DmgType) != none || class<DamTypePipeBomb>(DmgType) != none ||
         class<DamTypeM79Grenade>(DmgType) != none || class<DamTypeM32Grenade>(DmgType) != none ||
         class<DamTypeRocketImpact>(DmgType) != none )
        return float(InDamage) * FMax(0.75 - (0.05 * float(KFPRI.ClientVeteranSkillLevel)),0.f);
    return InDamage;
}

//Copied from KFVetDemolitions 
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'PipeBombPickup' ) {
        return 0.5 - (0.04 * float(KFPRI.ClientVeteranSkillLevel)); 
    }
    else if ( Item == class'M79Pickup' || Item == class 'M32Pickup' || Item == class 'KFCommBeta.KFCBLawPickup' ) {
        return 0.90 - (0.10 * float(KFPRI.ClientVeteranSkillLevel));
    }
    return 1.0;
}

//Copied from KFVetDemolitions
static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'PipeBombPickup' ) {
        return 0.5 - (0.04 * float(KFPRI.ClientVeteranSkillLevel)); 
    }
    else if ( Item == class'M79Pickup' || Item == class'M32Pickup' || Item == class'KFCommBeta.KFCBLAWPickup' ) {
        return 1.0 - (0.05 * float(KFPRI.ClientVeteranSkillLevel));
    }
    return 1.0;
}


// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5, give them a pipe bomb
    if ( KFPRI.ClientVeteranSkillLevel >= 5 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.PipeBombExplosive", GetCostScaling(KFPRI, class'PipeBombPickup'));
    // If Level 6, give them a M79Grenade launcher and pipe bomb
    if ( KFPRI.ClientVeteranSkillLevel >= default.maxStockLevel )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.M79GrenadeLauncher", GetCostScaling(KFPRI, class'M79Pickup'));
}

static function string GetCustomLevelInfo( byte Level ) {
    return default.LevelEffects[6];
}

defaultproperties {
     maxStockLevel=6

     PerkIndex=6
     OnHUDIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Demolition'
     OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Demolition_Gold'
     VeterancyName="1017Demolitions"

     PerkProgressArray(0)=5000
     PerkProgressArray(1)=25000
     PerkProgressArray(2)=100000
     PerkProgressArray(3)=500000
     PerkProgressArray(4)=1500000
     PerkProgressArray(5)=3500000
     PerkProgressArray(6)=5500000

     Requirements(0)="Deal %x damage with the Explosives"

     LevelEffects(0)="5% extra Explosives damage|25% resistance to Explosives|10% discount on Explosives|50% off Remote Explosives"
     LevelEffects(1)="10% extra Explosives damage|30% resistance to Explosives|20% increase in grenade capacity|Can carry 3 Remote Explosives|20% discount on Explosives|54% off Remote Explosives"
     LevelEffects(2)="20% extra Explosives damage|35% resistance to Explosives|40% increase in grenade capacity|Can carry 4 Remote Explosives|30% discount on Explosives|58% off Remote Explosives"
     LevelEffects(3)="30% extra Explosives damage|40% resistance to Explosives|60% increase in grenade capacity|Can carry 5 Remote Explosives|40% discount on Explosives|62% off Remote Explosives"
     LevelEffects(4)="40% extra Explosives damage|45% resistance to Explosives|80% increase in grenade capacity|Can carry 6 Remote Explosives|50% discount on Explosives|66% off Remote Explosives"
     LevelEffects(5)="50% extra Explosives damage|50% resistance to Explosives|100% increase in grenade capacity|Can carry 7 Remote Explosives|60% discount on Explosives|70% off Remote Explosives|Spawn with a Pipe Bomb"
     LevelEffects(6)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|74% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
     CustomLevelInfo="%s extra Explosives damage|%r resistance to Explosives|120% increase in grenade capacity|Can carry %x Remote Explosives|%y discount on Explosives|%d off Remote Explosives|Spawn with an M79 and Pipe Bomb"
}
