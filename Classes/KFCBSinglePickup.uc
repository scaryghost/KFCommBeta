class KFCBSinglePickup extends SinglePickup;

function inventory SpawnCopy( pawn Other )
{
	local Inventory I;

	For( I=Other.Inventory; I!=None; I=I.Inventory )
	{
		if( KFCBSingle(I)!=None )
		{
			if( Inventory!=None )
				Inventory.Destroy();
			InventoryType = Class'KFCommBeta.KFCBDualies';
			I.Destroyed();
			I.Destroy();
			return Super(KFWeaponPickup).SpawnCopy(Other);
		}
	}
	InventoryType = Default.InventoryType;
	Return Super(KFWeaponPickup).SpawnCopy(Other);
}

defaultproperties {
    InventoryType=class'KFCommBeta.KFCBSingle'
    ItemName="KFCommBeta 9mm Pistol"
    ItemShortName="KFCB 9mm Pistol"
}
