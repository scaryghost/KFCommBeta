class KF1017VetFieldMedic extends SRVeterancyTypes
    abstract;

var int maxStockLevel;
var array<int> PerkProgressArray;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum ) {
    if (CurLevel <= default.maxStockLevel) {
        FinalInt= default.PerkProgressArray[CurLevel];
    } else {
        FinalInt = 100000+GetDoubleScaling(CurLevel,20000);
    }

    return Min(StatOther.RDamageHealedStat,FinalInt);
}

static function float GetSyringeChargeRate(KFPlayerReplicationInfo KFPRI) {
    if ( KFPRI.ClientVeteranSkillLevel == 0 )
        return 1.10;
    else if ( KFPRI.ClientVeteranSkillLevel <= 4 )
        return 1.25 + (0.25 * float(KFPRI.ClientVeteranSkillLevel));
    else if ( KFPRI.ClientVeteranSkillLevel == 5 )
        return 2.50; // Recharges 150% faster
    return 3.0; // Level 6 - Recharges 200% faster
}

static function float GetHealPotency(KFPlayerReplicationInfo KFPRI) {
    if ( KFPRI.ClientVeteranSkillLevel == 0 )
        return 1.10;
    else if ( KFPRI.ClientVeteranSkillLevel <= 2 )
        return 1.25;
    else if ( KFPRI.ClientVeteranSkillLevel <= 5 )
        return 1.5;
    return 1.75;  // Heals for 75% more
}

//Copied this form KFVetFieldMedic
static function float GetMovementSpeedModifier(KFPlayerReplicationInfo KFPRI) {
    // Medic movement speed reduced in Balance Round 2(limited to Suicidal and HoE in Round 7)
    if ( KFPRI.Level.Game.GameDifficulty >= 5.0 ) {
        if ( KFPRI.ClientVeteranSkillLevel <= 2 ) {
            return 1.0;
        }

        return 1.05 + (0.05 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel) - 3)); // Moves up to 20% faster
    }

    if ( KFPRI.ClientVeteranSkillLevel <= 1 ) {
        return 1.0;
    }

    return 1.05 + (0.05 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel) - 2)); // Moves up to 25% faster
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster DamageTaker, int InDamage, class<DamageType> DmgType) {
    if ( DmgType == class'DamTypeVomit' ) {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return float(InDamage) * 0.90;
        else if ( KFPRI.ClientVeteranSkillLevel == 1 )
            return float(InDamage) * 0.75;
        else if ( KFPRI.ClientVeteranSkillLevel <= 4 )
            return float(InDamage) * 0.50;
        return float(InDamage) * 0.25; // 75% decrease in damage from Bloat's Bile
    }
    return InDamage;
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    if ( MP7MMedicGun(Other) != none && KFPRI.ClientVeteranSkillLevel > 0 )
        return 1.0 + (0.20 * FMin(KFPRI.ClientVeteranSkillLevel, 5.0)); // 100% increase in MP7 Medic weapon ammo carry
    return 1.0;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other) {
    if ( MP7MAmmo(Other) != none && KFPRI.ClientVeteranSkillLevel > 0 )
        return 1.0 + (0.20 * FMin(KFPRI.ClientVeteranSkillLevel, 5.0)); // 100% increase in MP7 Medic weapon ammo carry
    return 1.0;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'Vest' )
        return FMax(0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)),0.3f);  // Up to 70% discount on Body Armor
    else if ( Item == class'MP7MPickup' )
        return FMax(0.15 - (0.02 * float(KFPRI.ClientVeteranSkillLevel)),0.03f);  // Up to 97% discount on Medic Gun
    return 1.0;
}

// Reduce damage when wearing Armor
static function float GetBodyArmorDamageModifier(KFPlayerReplicationInfo KFPRI) {
    if ( KFPRI.ClientVeteranSkillLevel <= 5 )
        return 1.0 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 50% improvement of Body Armor
    return 0.25; // Level 6 - 75% Better Body Armor
}

// Give Extra Items as Default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5 or Higher, give them Body Armor
    if ( KFPRI.ClientVeteranSkillLevel >= 5 )
        P.ShieldStrength = 100;
    // If Level 6, give them a Medic Gun
    if ( KFPRI.ClientVeteranSkillLevel >= 6 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.MP7MMedicGun", GetCostScaling(KFPRI, class'MP7MPickup'));
}

static function string GetCustomLevelInfo( byte Level ) {
    return default.LevelEffects[6];
}

defaultproperties {
     maxStockLevel=6

     PerkIndex=0
     OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Medic'
     OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Medic_Gold'
     VeterancyName="1017FieldMedic"

     PerkProgressArray(0)=100
     PerkProgressArray(1)=200
     PerkProgressArray(2)=750
     PerkProgressArray(3)=4000
     PerkProgressArray(4)=12000
     PerkProgressArray(5)=25000
     PerkProgressArray(6)=100000

     Requirements(0)="Heal %x HP on your teammates"

     LevelEffects(0)="10% faster Syringe recharge|10% more potent medical injections|10% less damage from Bloat Bile|10% discount on Body Armor|85% discount on MP7M Medic Gun"
     LevelEffects(1)="25% faster Syringe recharge|25% more potent medical injections|25% less damage from Bloat Bile|20% larger MP7M Medic Gun clip|10% better Body Armor|20% discount on Body Armor|87% discount on MP7M Medic Gun"
     LevelEffects(2)="50% faster Syringe recharge|25% more potent medical injections|50% less damage from Bloat Bile|5% faster movement speed|40% larger MP7M Medic Gun clip|20% better Body Armor|30% discount on Body Armor|89% discount on MP7M Medic Gun"
     LevelEffects(3)="75% faster Syringe recharge|50% more potent medical injections|50% less damage from Bloat Bile|10% faster movement speed|60% larger MP7M Medic Gun clip|30% better Body Armor|40% discount on Body Armor|91% discount on MP7M Medic Gun"
     LevelEffects(4)="100% faster Syringe recharge|50% more potent medical injections|50% less damage from Bloat Bile|15% faster movement speed|80% larger MP7M Medic Gun clip|40% better Body Armor|50% discount on Body Armor|93% discount on MP7M Medic Gun"
     LevelEffects(5)="150% faster Syringe recharge|50% more potent medical injections|75% less damage from Bloat Bile|20% faster movement speed|100% larger MP7M Medic Gun clip|50% better Body Armor|60% discount on Body Armor|95% discount on MP7M Medic Gun|Spawn with Body Armor"
     LevelEffects(6)="200% faster Syringe recharge|75% more potent medical injections|75% less damage from Bloat Bile|25% faster movement speed|100% larger MP7M Medic Gun clip|75% better Body Armor|70% discount on Body Armor||97% discount on MP7M Medic Gun| Spawn with Body Armor and Medic Gun"
}
//     CustomLevelInfo="%s faster Syringe recharge|75% more potent medical injections|75% less damage from Bloat Bile|r% faster movement speed|100% larger MP7M Medic Gun clip|75% better Body Armor|%d discount on Body Armor||%m discount on MP7M Medic Gun| Spawn with Body Armor and Medic Gun"
