class KFCBMagnum44Pistol extends Magnum44Pistol;

simulated function bool PutDown() {
    if ( Instigator.PendingWeapon.class == class'KFCommBeta.KFCBDual44Magnum' ) {
        bIsReloading = false;
    }

    return super(KFWeapon).PutDown();
}


defaultproperties {
    Weight=2.000000
    ItemName="KFCommBeta 44 Magnum"
    PickupClass=Class'KFCommBeta.KFCBMagnum44Pickup'
}
