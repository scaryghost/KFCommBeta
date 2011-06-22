class KFCBVetSharpshooter extends KF1017VetSharpshooter;

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    /**
     *  Wave 2:
     *      Give Winchester, then Deagle at perk levels 5 and 6 respectively
     */
    if ( KFPRI.ClientVeteranSkillLevel == 5 ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFCommBeta.KFCBWinchester", GetCostScaling(KFPRI, class'KFCommBeta.KFCBWinchesterPickup'));
    } else if ( KFPRI.ClientVeteranSkillLevel >= default.maxStockLevel ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Deagle", GetCostScaling(KFPRI, class'DeaglePickup'));
    }
}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    /**
     *  Wave 2:
     *      Added discount for the winchester
     */
    if ( Item == class'DeaglePickup' || Item == class'DualDeaglePickup' || Item == class'KFCommBeta.KFCBM14EBRPickup' || Item == class'KFCommBeta.KFCBWinchesterPickup')
        return FMax(0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)),0.3f); // Up to 70% discount on Handcannon/Dual Handcannons/EBR
    return 1.0;
}

defaultproperties {
    VeterancyName= "KFCommBetaSharpshooter"

    LevelEffects(6)="140% more headshot damage with 9mm, Handcannon, Rifle, Crossbow, and M14|75% less recoil with Handcannon, Rifle, Crossbow, and M14|60% faster reload with Handcannon, Rifle, Crossbow, and M14|50% extra headshot damage|70% discount on Handcannon/M14|Spawn with a Deagle"

}

