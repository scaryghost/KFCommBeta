class KFCBVetBerserker extends BaseVetBerserker
    abstract;

struct damReduction {
    var float bloatDamRed;
    var float genDamRed;
};

var array<damReduction> ReduceDamageArray;

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster DamageTaker, int InDamage, class<DamageType> DmgType) {
    /** Vomit - DamTypeVomit
     *  Husk - DamTypeBurned
     *  Siren - SirenScreamDamage, DamTypeSlashingAttack
     *  Stalker - DamTypeSlashingAttack
     * 
     *  Wave 1 - Only reduction from melee attacks
     *  Wave 2 - Added back some resistance to vomit, up to 40% at level 6.  
     *  Wave 3 - Reverted damage resistances back to pre-balance patch levels, 
     *              save for a small 5% increase at level 6
     */

    if ( DmgType == class'DamTypeVomit' ) {
        return float(InDamage) * default.ReduceDamageArray[min(KFPRI.ClientVeteranSkillLevel,6)].bloatDamRed;
    }

    return float(InDamage) * default.ReduceDamageArray[min(KFPRI.ClientVeteranSkillLevel,6)].genDamRed; 

}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    /**
     *  Wave 2:
     *      Give axe at level 5, katana at level 6
     */
    if ( KFPRI.ClientVeteranSkillLevel == 5 ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Axe", GetCostScaling(KFPRI, class'AxePickup'));
    } else if ( KFPRI.ClientVeteranSkillLevel >= 6 ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Katana", GetCostScaling(KFPRI, class'KatanaPickup'));
    }
}


defaultproperties {
    VeterancyName= "KFCommBetaBerserker"

    ReduceDamageArray(0)= (bloatDamRed=0.90,genDamRed=1.00)
    ReduceDamageArray(1)= (bloatDamRed=0.75,genDamRed=0.95)
    ReduceDamageArray(2)= (bloatDamRed=0.65,genDamRed=0.90)
    ReduceDamageArray(3)= (bloatDamRed=0.50,genDamRed=0.85)
    ReduceDamageArray(4)= (bloatDamRed=0.35,genDamRed=0.80)
    ReduceDamageArray(5)= (bloatDamRed=0.25,genDamRed=0.75)
    ReduceDamageArray(6)= (bloatDamRed=0.20,genDamRed=0.70)

    LevelEffects(0)="10% extra melee damage|5% faster melee movement|10% resistance to bloat bile|10% discount on Katana/Chainsaw|Can't be grabbed by Clots"
    LevelEffects(1)="20% extra melee damage|5% faster melee attacks|10% faster melee movement|25% resistance to bloat bile|5% resistance to other damage|20% discount on Katana/Chainsaw|Can't be grabbed by Clots"
    LevelEffects(2)="40% extra melee damage|10% faster melee attacks|15% faster melee movement|35% resistance to bloat bile|10% resistance to other damage|30% discount on Katana/Chainsaw|Can't be grabbed by Clots|Zed-Time can be extended by killing an enemy while in slow motion"
    LevelEffects(3)="60% extra melee damage|10% faster melee attacks|20% faster melee movement|50% resistance to bloat bile|15% resistance to other damage|40% discount on Katana/Chainsaw|Can't be grabbed by Clots|Up to 2 Zed-Time Extensions"
    LevelEffects(4)="80% extra melee damage|15% faster melee attacks|20% faster melee movement|65% resistance to bloat bile|20% resistance to other damage|50% discount on Katana/Chainsaw|Can't be grabbed by Clots|Up to 3 Zed-Time Extensions"
    LevelEffects(5)="100% extra melee damage|20% faster melee attacks|20% faster melee movement|75% resistance to bloat bile|25% resistance to other damage|60% discount on Katana/Chainsaw|Spawn with an Axe|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    LevelEffects(6)="100% extra melee damage|25% faster melee attacks|25% faster melee movement|80% resistance to bloat bile|30% resistance to other damage|70% discount on Katana/Chainsaw|Spawn with a Katana|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
}
