class BaseVetFieldMedic extends SRVetFieldMedic
    abstract;

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'Vest' ) {
        return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel));  // Up to 70% discount on Body Armor
    }
    else if ( Item == class'MP7MPickup' || Item == class'MP5MPickup' ) {
        return 0.25 - (0.02 * float(KFPRI.ClientVeteranSkillLevel));  // Up to 87% discount on Medic Gun
    }

    return 1.0;
}


defaultproperties {
     VeterancyName="KFVetFieldMedic"
}
