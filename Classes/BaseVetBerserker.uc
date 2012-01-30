class BaseVetBerserker extends SRVetBerserker
    abstract;

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5 or 6, give them Chainsaw
    if ( KFPRI.ClientVeteranSkillLevel >= 5 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFCommBeta.KFCBChainsaw", GetCostScaling(KFPRI, class'KFCBChainsawPickup'));

    // If Level 6, give them Body Armor(Removed from Suicidal and HoE in Balance Round 7)
    if ( KFPRI.Level.Game.GameDifficulty < 5.0 && KFPRI.ClientVeteranSkillLevel == 6 )
        P.ShieldStrength = 100;
}

defaultproperties {
    VeterancyName="KFVetBerserker"
}
