class KFVetSharpshooter extends SRVetSharpshooter
    abstract;

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil) {
    if ( Crossbow(Other.Weapon) != none || Winchester(Other.Weapon) != none
        || Single(Other.Weapon) != none || Dualies(Other.Weapon) != none
        || Deagle(Other.Weapon) != none || DualDeagle(Other.Weapon) != none
        || M14EBRBattleRifle(Other.Weapon) != none ) {
        if ( KFPRI.ClientVeteranSkillLevel == 1) {
            Recoil = 0.75;
        }
        else if ( KFPRI.ClientVeteranSkillLevel == 2 )  {
            Recoil = 0.50;
        }
        else {
            Recoil = 0.25; // 75% recoil reduction with Crossbow/Winchester/Handcannon
        }

        return Recoil;
    }

    Recoil = 1.0;
    Return Recoil;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    if ( Crossbow(Other) != none || Winchester(Other) != none
         || Single(Other) != none || Dualies(Other) != none
         || Deagle(Other) != none || DualDeagle(Other) != none
         || M14EBRBattleRifle(Other) != none || Magnum44Pistol(Other) != none
         || Dual44Magnum(Other) != none ) {

        if ( KFPRI.ClientVeteranSkillLevel == 0 ) {
            return 1.0;
        }

        return 1.0 + (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 60% faster reload with Crossbow/Winchester/Handcannon
    }

    return 1.0;
}

defaultproperties {
     VeterancyName="KFVetSharpshooter"
}
