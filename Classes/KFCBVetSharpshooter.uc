class KFCBVetSharpshooter extends KF1017VetSharpshooter;

static function float GetHeadShotDamMulti(KFPlayerReplicationInfo KFPRI, class<DamageType> DmgType) {
    local float ret;

    // Removed extra SS Crossbow headshot damage in Round 1(added back in Round 2) and Removed Single/Dualies Damage for Hell on Earth in Round 6
    // Added Dual Deagles back in for Balance Round 7
    if ( DmgType == class'DamTypeCrossbow' || DmgType == class'DamTypeCrossbowHeadShot' || DmgType == class'DamTypeWinchester' ||
         DmgType == class'DamTypeDeagle' || DmgType == class'DamTypeDualDeagle' || DmgType == class'KFCommBeta.KFCBDamTypeM14EBR' ||
         (DmgType == class'DamTypeDualies' && KFPRI.Level.Game.GameDifficulty < 7.0) ) {
        if ( KFPRI.ClientVeteranSkillLevel <= 3 )  {
            ret = 1.05 + (0.05 * float(KFPRI.ClientVeteranSkillLevel));
        }
        else if ( KFPRI.ClientVeteranSkillLevel == 4 ) {
            ret = 1.30;
        }
        else if ( KFPRI.ClientVeteranSkillLevel == 5 ) {
            ret = 1.50;
        }
        else {
            ret = 1.60; // 60% increase in Crossbow/Winchester/Handcannon damage
        }
    }
    // Reduced extra headshot damage for Single/Dualies in Hell on Earth difficulty(added in Balance Round 6)
    else if ( DmgType == class'DamTypeDualies' && KFPRI.Level.Game.GameDifficulty >= 7.0 ) {
        return (1.0 + (0.08 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)))); // 40% increase in Headshot Damage
    }
    else {
        ret = 1.0; // Fix for oversight in Balance Round 6(which is the reason for the Round 6 second attempt patch)
    }

    if ( KFPRI.ClientVeteranSkillLevel == 0 ) {
        return ret * 1.05;
    }

    return ret * (1.0 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)))); // 50% increase in Headshot Damage
}

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

