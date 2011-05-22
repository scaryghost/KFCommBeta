class KFCBVetBerserker extends KF1017VetBerserker
    abstract;

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster DamageTaker, int InDamage, class<DamageType> DmgType) {
    /** Vomit - DamTypeVomit
     *  Husk - DamTypeBurned
     *  Siren - SirenScreamDamage, DamTypeSlashingAttack
     *  Stalker - DamTypeSlashingAttack
     * 
     *  Wave 1 - Only reduction from melee attacks
     *  Wave 2 - Added back some resistance to vomit, up to 40% at level 6.  
     */

    if (DmgType == class'DamTypeSlashingAttack' || DmgType == class'DamTypeClaws' 
        || DmgType == class'ZombieMeleeDamage' || DmgType == class'DamTypeVomit') {
        return float(InDamage) * default.ReduceDamageArray[min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel)].genDamRed;
    }
    return InDamage;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    /**
     *  Wave 2:
     *      Give axe at level 5, katana at level 6
     */
    if ( KFPRI.ClientVeteranSkillLevel == 5 ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Axe", GetCostScaling(KFPRI, class'AxePickup'));
    } else if ( KFPRI.ClientVeteranSkillLevel >= default.maxStockLevel ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Katana", GetCostScaling(KFPRI, class'KatanaPickup'));
    }
}


defaultproperties {
    VeterancyName= "KFCommBetaBerserker"

    MeleeMovementSpeedModArray(0)= 0.05
    MeleeMovementSpeedModArray(1)= 0.10
    MeleeMovementSpeedModArray(2)= 0.15
    MeleeMovementSpeedModArray(3)= 0.20
    MeleeMovementSpeedModArray(4)= 0.20
    MeleeMovementSpeedModArray(5)= 0.20
    MeleeMovementSpeedModArray(6)= 0.25

    LevelEffects(0)="10% extra melee damage|5% faster melee movement|10% discount on Katana/Chainsaw|Can't be grabbed by Clots"
    LevelEffects(1)="20% extra melee damage|5% faster melee attacks|10% faster melee movement|5% resistance to melee damage and Bloat bile|20% discount on Katana/Chainsaw|Can't be grabbed by Clots"
    LevelEffects(2)="40% extra melee damage|10% faster melee attacks|15% faster melee movement|10% resistance to melee damage and Bloat bile|30% discount on Katana/Chainsaw|Can't be grabbed by Clots|Zed-Time can be extended by killing an enemy while in slow motion"
    LevelEffects(3)="60% extra melee damage|10% faster melee attacks|20% faster melee movement|15% resistance to melee damage and Bloat bile|40% discount on Katana/Chainsaw|Can't be grabbed by Clots|Up to 2 Zed-Time Extensions"
    LevelEffects(4)="80% extra melee damage|15% faster melee attacks|20% faster melee movement|25% resistance to melee damage and Bloat bile|50% discount on Katana/Chainsaw|Can't be grabbed by Clots|Up to 3 Zed-Time Extensions"
    LevelEffects(5)="100% extra melee damage|20% faster melee attacks|20% faster melee movement|30% resistance to melee damage and Bloat bile|60% discount on Katana/Chainsaw|Spawn with an Axe|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    LevelEffects(6)="100% extra melee damage|25% faster melee attacks|25% faster melee movement|40% resistance to melee damage and Bloat bile|70% discount on Katana/Chainsaw|Spawn with a Katana|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
}
