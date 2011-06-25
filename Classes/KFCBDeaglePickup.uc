class KFCBDeaglePickup extends DeaglePickup;

function inventory SpawnCopy( pawn Other )
{
	local Inventory I;

	For( I=Other.Inventory; I!=None; I=I.Inventory )
	{
		if( KFCBDeagle(I)!=None )
		{
			if( Inventory!=None )
				Inventory.Destroy();
			InventoryType = Class'KFCommBeta.KFCBDualDeagle';
            AmmoAmount[0]+= KFCBDeagle(I).AmmoAmount(0);
			I.Destroyed();
			I.Destroy();
			Return Super(KFWeaponPickup).SpawnCopy(Other);
		}
	}
	InventoryType = Default.InventoryType;
	Return Super(KFWeaponPickup).SpawnCopy(Other);
}

defaultproperties {
    ItemName="KFCommBeta Handcannon"
    ItemShortName="KFCB Handcannon"
    InventoryType=class'KFCommBeta.KFCBDeagle'
}
