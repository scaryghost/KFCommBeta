class KFCBVetSharpshooter extends KF1017VetSharpshooter;

// Give Extra Items as Default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5, give them a  Lever Action Rifle
    if ( KFPRI.ClientVeteranSkillLevel == 5 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Winchester", GetCostScaling(KFPRI, class'WinchesterPickup'));

    // If Level 6, give them a Crossbow
    if ( KFPRI.ClientVeteranSkillLevel >= 6 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Deagle", GetCostScaling(KFPRI, class'DeaglePickup'));
}


defaultproperties {
    VeterancyName= "KFCommBetaSharpshooter"

    LevelEffects(6)="140% more headshot damage with 9mm, Handcannon, Rifle, Crossbow, and M14|75% less recoil with Handcannon, Rifle, Crossbow, and M14|60% faster reload with Handcannon, Rifle, Crossbow, and M14|50% extra headshot damage|70% discount on Handcannon/M14|Spawn with a Deagle"

}

