class KFCBChainsawAmmo extends ChainsawAmmo;

defaultproperties {
    bAcceptsAmmoPickups= true;
    PickupClass=class'KFCommBeta.KFCBChainsawAmmoPickup'

    /**
     *  Set up "fuel" for the chainsaw
     *  Wave 3:
     *      Cost:       £15 per 100 units
     *      Max Ammo    2000 units
     *      Ammo Pickup 100 units
     */
    AmmoPickupAmount=100
    MaxAmmo= 1500;
    InitialAmount= 1500;
}
