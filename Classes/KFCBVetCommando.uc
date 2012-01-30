class KFCBVetCommando extends BaseVetCommando
    abstract;


static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType) {
    /**
     *  Give slightly extra damage to the commando
     *  Wave 4:
     *      Upped the level 6 damage to 60%
     *
     *  Wave 5:
     *      Gave damage bonus to dual 9mm, up to 60% at level 6
     */
    if ( DmgType == class'DamTypeBullpup' || DmgType == class'DamTypeAK47AssaultRifle' 
        || DmgType == class'DamTypeSCARMK17AssaultRifle' || DmgType == class'DamTypeM4AssaultRifle'
        || DmgType == class'DamTypeDualies') {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return float(InDamage) * 1.05;
        return float(InDamage) * (1.00 + (0.10 * float(KFPRI.ClientVeteranSkillLevel)));
    }
    return InDamage;
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil) {
    /**
     *  Wave 5: Added dualies to the recoil reduction bonus, 40% @ level 6
     */
    if ( Bullpup(Other.Weapon) != none || AK47AssaultRifle(Other.Weapon) != none 
        || SCARMK17AssaultRifle(Other.Weapon) != none || M4AssaultRifle(Other.Weapon) != none
        || KFCBDualies(Other.Weapon) != none) {
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

defaultproperties {
    VeterancyName="KFCommBetaCommando"

    LevelEffects(0)="5% more damage with Bullpup/AK47/SCAR/Dual 9mm|5% less recoil with Bullpup/AK47/SCAR/Dual 9mm|5% faster reload with all weapons|10% discount on Bullpup/AK47/SCAR|Can see cloaked Stalkers from 4 meters"
    LevelEffects(1)="10% more damage with Bullpup/AK47/SCAR/Dual 9mm|10% less recoil with Bullpup/AK47/SCAR/Dual 9mm|10% larger Bullpup/AK47/SCAR clip|10% faster reload with all weapons|20% discount on Bullpup/AK47/SCAR|Can see cloaked Stalkers from 8m|Can see enemy health from 4m"
    LevelEffects(2)="20% more damage with Bullpup/AK47/SCAR/Dual 9mm|15% less recoil with Bullpup/AK47/SCAR/Dual 9mm|20% larger Bullpup/AK47/SCAR clip|15% faster reload with all weapons|30% discount on Bullpup/AK47/SCAR|Can see cloaked Stalkers from 10m|Can see enemy health from 7m"
    LevelEffects(3)="30% more damage with Bullpup/AK47/SCAR/Dual 9mm|20% less recoil with Bullpup/AK47/SCAR/Dual 9mm|25% larger Bullpup/AK47/SCAR clip|20% faster reload with all weapons|40% discount on Bullpup/AK47/SCAR|Can see cloaked Stalkers from 12m|Can see enemy health from 10m|Zed-Time can be extended by killing an enemy while in slow motion"
    LevelEffects(4)="40% more damage with Bullpup/AK47/SCAR/Dual 9mm|30% less recoil with Bullpup/AK47/SCAR/Dual 9mm|25% larger Bullpup/AK47/SCAR clip|25% faster reload with all weapons|50% discount on Bullpup/AK47/SCAR|Can see cloaked Stalkers from 14m|Can see enemy health from 13m|Up to 2 Zed-Time Extensions"
    LevelEffects(5)="50% more damage with Bullpup/AK47/SCAR/Dual 9mm|30% less recoil with Bullpup/AK47/SCAR/Dual 9mm|25% larger Bullpup/AK47/SCAR clip|30% faster reload with all weapons|60% discount on Bullpup/AK47/SCAR|Spawn with a Bullpup|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 3 Zed-Time Extensions"
    LevelEffects(6)="60% more damage with Bullpup/AK47/SCAR/Dual 9mm|40% less recoil with Bullpup/AK47/SCAR/Dual 9mm|25% larger Bullpup/AK47/SCAR clip|35% faster reload with all weapons|70% discount on Bullpup/AK47/SCAR|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
}
