class KFCBChainsawPickup extends ChainsawPickup;

defaultproperties {
    /**
     *  Make the chainsaw more beastly
     *  Wave 2:
     *      Up the cost to 2500
     */
    cost= 2500;

    /**
     *  Set up "fuel" for the chainsaw
     *  Wave 3:
     *      Cost:       £15 per 100 units
     *      Max Ammo    2000 units
     *      Ammo Pickup 100 units
     */
    AmmoCost= 15;
    BuyClipSize= 100;
    AmmoItemName= "Chainsaw fuel";

    ItemName="KFCommBeta Chainsaw"
    ItemShortName="KFCB Chainsaw"
    InventoryType=class'KFCommBeta.KFCBChainsaw'
}
