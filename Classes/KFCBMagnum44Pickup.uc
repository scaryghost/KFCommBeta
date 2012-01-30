class KFCBMagnum44Pickup extends Magnum44Pickup;

function inventory SpawnCopy( pawn Other ) {
    local Inventory I;

    For( I=Other.Inventory; I!=None; I=I.Inventory ) {
        if( KFCBMagnum44Pistol(I)!=None ) {
            if( Inventory!=None )
                Inventory.Destroy();
            InventoryType = Class'KFCommBeta.KFCBDual44Magnum';
            AmmoAmount[0]+= KFCBMagnum44Pistol(I).AmmoAmount(0);
            I.Destroyed();
            I.Destroy();
            Return Super(KFWeaponPickup).SpawnCopy(Other);
        }
    }
    InventoryType = Default.InventoryType;
    Return Super(KFWeaponPickup).SpawnCopy(Other);
}

defaultproperties {
    ItemName="KFCommBeta 44 Magnum"
    ItemShortName="KFCB 44 Magnum"
    InventoryType=Class'KFCommBeta.KFCBMagnum44Pistol'
}
