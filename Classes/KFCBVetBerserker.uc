class KFCBVetBerserker extends KF1017VetBerserker
    abstract;

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster DamageTaker, int InDamage, class<DamageType> DmgType) {
    /** Vomit - DamTypeVomit
     *  Husk - DamTypeBurned
     *  Siren - SirenScreamDamage, DamTypeSlashingAttack
     *  Stalker - DamTypeSlashingAttack
     * 
     *  Wave 1 - Only reduction from melee attacks
     */

    if (DmgType == class'DamTypeSlashingAttack' || DmgType == class'DamTypeClaws' || DmgType == class'ZombieMeleeDamage') {
        return float(InDamage) * default.ReduceDamageArray[min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel)].genDamRed;
    }
    return InDamage;
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

    LevelEffects(0)="10% extra melee damage|5% faster melee movement|10% less damage from Bloat Bile|10% discount on Katana/Chainsaw|Can't be grabbed by Clots"
    LevelEffects(1)="20% extra melee damage|5% faster melee attacks|10% faster melee movement|25% less damage from Bloat Bile|5% resistance to melee damage|20% discount on Katana/Chainsaw|Can't be grabbed by Clots"
    LevelEffects(2)="40% extra melee damage|10% faster melee attacks|15% faster melee movement|35% less damage from Bloat Bile|10% resistance to melee damage|30% discount on Katana/Chainsaw|Can't be grabbed by Clots|Zed-Time can be extended by killing an enemy while in slow motion"
    LevelEffects(3)="60% extra melee damage|10% faster melee attacks|20% faster melee movement|50% less damage from Bloat Bile|15% resistance to melee damage|40% discount on Katana/Chainsaw|Can't be grabbed by Clots|Up to 2 Zed-Time Extensions"
    LevelEffects(4)="80% extra melee damage|15% faster melee attacks|20% faster melee movement|65% less damage from Bloat Bile|25% resistance to melee damage|50% discount on Katana/Chainsaw|Can't be grabbed by Clots|Up to 3 Zed-Time Extensions"
    LevelEffects(5)="100% extra melee damage|20% faster melee attacks|20% faster melee movement|75% less damage from Bloat Bile|30% resistance to melee damage|60% discount on Katana/Chainsaw|Spawn with a Chainsaw|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    LevelEffects(6)="100% extra melee damage|25% faster melee attacks|25% faster melee movement|80% less damage from Bloat Bile|40% resistance to melee damage|70% discount on Katana/Chainsaw|Spawn with a Chainsaw and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
}
