class KFCBGuiBuyMenu extends SRGUIBuyMenu;

function InitTabs() {
    c_Tabs.AddTab(PanelCaption[0], string(Class'KFCBTab_BuyMenu'),, PanelHint[0]);
    c_Tabs.AddTab(PanelCaption[1], string(Class'SRKFTab_Perks'),, PanelHint[1]);
}

