class BaseVetSharpshooter extends SRVetSharpshooter
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

// Give Extra Items as Default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5, give them a  Lever Action Rifle
    if ( KFPRI.ClientVeteranSkillLevel == 5 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFCommBeta.KFCBWinchester", GetCostScaling(KFPRI, class'KFCBWinchesterPickup'));

    // If Level 6, give them a Crossbow
    if ( KFPRI.ClientVeteranSkillLevel >= 6 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFCommBeta.KFCBCrossbow", GetCostScaling(KFPRI, class'KFCBCrossbowPickup'));
}

defaultproperties {
     VeterancyName="KFVetSharpshooter"

     LevelEffects(0)="5% more damage with Pistols, Rifle, Crossbow, and M14|5% extra Headshot damage with all weapons|10% discount on Handcannon/M14"
     LevelEffects(1)="10% more damage with Pistols, Rifle, Crossbow, and M14|25% less recoil with Pistols, Rifle, Crossbow, and M14|10% faster reload with Pistols, Rifle, Crossbow, and M14|10% extra headshot damage|20% discount on Handcannon/44 Magnum/M14"
     LevelEffects(2)="15% more damage with Pistols, Rifle, Crossbow, and M14|50% less recoil with Pistols, Rifle, Crossbow, and M14|20% faster reload with Pistols, Rifle, Crossbow, and M14|20% extra headshot damage|30% discount on Handcannon/44 Magnum/M14"
     LevelEffects(3)="20% more damage with Pistols, Rifle, Crossbow, and M14|75% less recoil with Pistols, Rifle, Crossbow, and M14|30% faster reload with Pistols, Rifle, Crossbow, and M14|30% extra headshot damage|40% discount on Handcannon/44 Magnum/M14"
     LevelEffects(4)="30% more damage with Pistols, Rifle, Crossbow, and M14|75% less recoil with Pistols, Rifle, Crossbow, and M14|40% faster reload with Pistols, Rifle, Crossbow, and M14|40% extra headshot damage|50% discount on Handcannon/44 Magnum/M14"
     LevelEffects(5)="50% more damage with Pistols, Rifle, Crossbow, and M14|75% less recoil with Pistols, Rifle, Crossbow, and M14|50% faster reload with Pistols, Rifle, Crossbow, and M14|50% extra headshot damage|60% discount on Handcannon/44 Magnum/M14|Spawn with a Lever Action Rifle"
     LevelEffects(6)="60% more damage with Pistols, Rifle, Crossbow, and M14|75% less recoil with Pistols, Rifle, Crossbow, and M14|60% faster reload with Pistols, Rifle, Crossbow, and M14|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14|Spawn with a Crossbow"
}
