class KFCBChainsaw extends Chainsaw;

defaultproperties {
    bAmmoHUDAsBar= true;
    bConsumesPhysicalAmmo= true;
    bMeleeWeapon= false;
    MagCapacity= 100;
    bShowChargingBar= true;

    FireModeClass(0)=class'KFCommBeta.KFCBChainsawFire'
    FireModeClass(1)=class'KFCommBeta.KFCBChainsawAltFire'

    PickupClass=class'KFCommBeta.KFCBChainsawPickup'
    ItemName="KFCommBeta Chainsaw"

    /**
     *  Make the chainsaw more beastly
     *  Wave 2:
     *      Decrease the slowdown rate to 0.20
     */
    ChopSlowRate=0.20;
}
