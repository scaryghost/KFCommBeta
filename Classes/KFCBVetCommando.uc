class KFCBVetCommando extends KF1017VetCommando
    abstract;


static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType) {
    /**
     *  Give slightly extra damage to the commando
     *  Wave 4:
     *      Upped the level 6 damage to 60%
     */
    if ( DmgType == class'DamTypeBullpup' || DmgType == class'DamTypeAK47AssaultRifle' || DmgType == class'DamTypeSCARMK17AssaultRifle' ) {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return float(InDamage) * 1.05;
        return float(InDamage) * (1.00 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel, default.maxStockLevel))));
    }
    return InDamage;
}

defaultproperties {
    VeterancyName="KFCommBetaCommando"

    LevelEffects(6)="60% more damage with Bullpup/AK47/SCAR|40% less recoil with Bullpup/AK47/SCAR|25% larger Bullpup/AK47/SCAR clip|35% faster reload with all weapons|70% discount on Bullpup/AK47/SCAR|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
}
