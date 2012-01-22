class KFCBVetFirebug extends BaseVetFirebug;

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    if ( KFPRI.ClientVeteranSkillLevel == 5 ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.MAC10MP", GetCostScaling(KFPRI, class'MAC10Pickup'));
    } else if ( KFPRI.ClientVeteranSkillLevel >= 6) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.FlameThrower", GetCostScaling(KFPRI, class'FlamethrowerPickup'));
    }
}

defaultproperties {
    VeterancyName= "KFCommBetaFirebug"
    LevelEffects(5)="50% extra Flamethrower/Mac10 damage|50% faster Flamethrower reload|25% faster Mac10 reload|50% larger fuel canister|60% larger Mac10 clip|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|60% discount on the FlameThrower/Mac10|Spawn with a Mac10"
     LevelEffects(6)="60% extra Flamethrower/Mac10 damage|60% faster Flamethrower reload|30% faster Mac10 reload|60% larger fuel canister|60% larger Mac10 clip|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on the FlameThrower/Mac10|Spawn with a Flamethrower"
}
