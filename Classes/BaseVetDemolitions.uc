class BaseVetDemolitions extends SRVetDemolitions;

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType) {
    if ( AmmoType == class'FragAmmo'  ) {
        // Up to 6 extra Grenades
        return 1.0 + (0.20 * float(KFPRI.ClientVeteranSkillLevel));
    }
    else if ( AmmoType == class'PipeBombAmmo' ) {
        // Up to 6 extra for a total of 8 Remote Explosive Devices
        return 1.0 + (0.5 * float(KFPRI.ClientVeteranSkillLevel));
    }
    else if ( AmmoType == class'LAWAmmo' ) {
        // Modified in Balance Round 5 to be up to 100% extra ammo
        return 1.0 + (0.20 * float(KFPRI.ClientVeteranSkillLevel));
    }

    return 1.0;

}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if (Item == class'PipeBombPickup' ) {
        return 0.5 - (0.04 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 74% discount on PipeBomb
    }
    else if (Item == class'M79Pickup' || Item == class 'M32Pickup'
        || Item == class 'LawPickup' || Item == class 'M4203Pickup') {
        return 0.90 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 70% discount on M79/M32
    }
    return 1.0;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if (Item == class'PipeBombPickup') {
        return 0.5 - (0.04 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 74% discount on PipeBomb
    }
    else if ( Item == class'M79Pickup' || Item == class'M32Pickup'
        || Item == class'LAWPickup' || Item == class'M4203Pickup') {
        return 1.0 - (0.05 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 30% discount on Grenade Launcher and LAW Ammo
    }

    return 1.0;

}

defaultproperties {
    VeterancyName="KFVetDemolitions"
}
