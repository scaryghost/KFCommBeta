class KFCBVetSupport extends BaseVetSupport
    abstract;

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType) {
    /**
     *  Wave 1 - Removed extra frag capacity
     */
    if ( AmmoType == class'ShotgunAmmo' || AmmoType == class'DBShotgunAmmo'
        || AmmoType == class'BenelliAmmo' || AmmoType == class'AA12Ammo' ) {
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
    /**
     *  Wave 1 - Removed extra frag damage
     *  Wave 5 - Added damage bonus for dual hand cannons, up to 60% at level 6
     */
    if ( DmgType == class'DamTypeShotgun' || DmgType == class'DamTypeDBShotgun' 
        || DmgType == class'DamTypeAA12Shotgun' || DmgType == class'DamTypeDualDeagle'
        || DmgType == class'DamTypeBenelli') {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return float(InDamage) * 1.10;
        return float(InDamage) * (1.00 + (0.10 * KFPRI.ClientVeteranSkillLevel)); 
    }
    return InDamage;
}

defaultproperties {
    VeterancyName= "KFCommBetaSupport"

    LevelEffects(0)="10% more damage with Shotguns and Dual Handcannons|10% better Shotgun penetration|10% faster welding/unwelding|10% discount on Shotguns"
    LevelEffects(1)="10% more damage with Shotguns and Dual Handcannons|18% better Shotgun penetration|10% extra shotgun ammo|15% increased carry weight|25% faster welding/unwelding|20% discount on Shotguns"
    LevelEffects(2)="20% more damage with Shotguns and Dual Handcannons|36% better Shotgun penetration|20% extra shotgun ammo|20% increased carry weight|50% faster welding/unwelding|30% discount on Shotguns"
    LevelEffects(3)="30% more damage with Shotguns and Dual Handcannons|54% better Shotgun penetration|25% extra shotgun ammo|25% increased carry weight|75% faster welding/unwelding|40% discount on Shotguns"
    LevelEffects(4)="40% more damage with Shotguns and Dual Handcannons|72% better Shotgun penetration|25% extra shotgun ammo|30% increased carry weight|100% faster welding/unwelding|50% discount on Shotguns"
    LevelEffects(5)="50% more damage with Shotguns and Dual Handcannons|90% better Shotgun penetration|25% extra shotgun ammo|50% increased carry weight|150% faster welding/unwelding|60% discount on Shotguns|Spawn with a Shotgun"
    LevelEffects(6)="60% more damage with Shotguns and Dual Handcannons|90% better Shotgun penetration|30% extra shotgun ammo|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
}
