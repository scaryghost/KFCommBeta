class KFCBDeagle extends Deagle;

simulated function bool PutDown()
{
	if ( Instigator.PendingWeapon.class == class'KFCommBeta.KFCBDualDeagle' )
	{
		bIsReloading = false;
	}

	return super(KFWeapon).PutDown();
}

defaultproperties {
    ItemName= "KFCommBeta Handcannon"
    PickupClass=class'KFCommBeta.KFCBDeaglePickup'
}
