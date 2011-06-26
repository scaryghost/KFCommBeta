class KFCBTab_BuyMenu extends SRKFTab_BuyMenu;

defaultproperties {
     Begin Object Class=KFCBBuyMenuInvListBox Name=InventoryBox
         OnCreateComponent=InventoryBox.InternalOnCreateComponent
         WinTop=0.070841
         WinLeft=0.000108
         WinWidth=0.328204
         WinHeight=0.521856
     End Object
     InvSelect=KFCBBuyMenuInvListBox'KFCommBeta.KFCBTab_BuyMenu.InventoryBox'

    Begin Object Class=KFCBBuyMenuSaleListBox Name=SaleBox
        OnCreateComponent=SaleBox.InternalOnCreateComponent
        WinTop=0.064312
        WinLeft=0.672632
        WinWidth=0.325857
        WinHeight=0.674039
    End Object
    SaleSelect=KFCBBuyMenuSaleListBox'KFCommBeta.KFCBTab_BuyMenu.SaleBox'
}
