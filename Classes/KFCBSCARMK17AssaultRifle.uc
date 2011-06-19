class KFCBSCARMK17AssaultRifle extends SCARMK17AssaultRifle
    config(user);

defaultproperties {
    /**
     *  Replace SCARMK17's default fire class
     *  See the fire class for more details
     */
    FireModeClass(0)=Class'KFCommBeta.KFCBSCARMK17Fire'

    ItemName="KFCommBeta SCARMK17"
    PickupClass=class'KFCommBeta.KFCBSCARMK17Pickup'
}
    
