class KFCBBuyMenuSaleList extends SRBuyMenuSaleList;

function UpdateForSaleBuyables()
{
	local class<KFVeterancyTypes> PlayerVeterancy;
    local KFPlayerReplicationInfo KFPRI;
	local KFLevelRules KFLR, KFLRit;
	local GUIBuyable ForSaleBuyable;
	local class<KFWeaponPickup> ForSalePickup;
	local int i, j, DualDivider, ForSaleArrayIndex;
	local bool bZeroWeight;

	DualDivider = 1;

	// Grab the items for sale
    foreach PlayerOwner().DynamicActors(class'KFLevelRules', KFLRit)
    {
        KFLR = KFLRit;
        Break;
	}

	// Grab Players Veterancy for quick reference
	if ( KFPlayerController(PlayerOwner()) != none && KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		PlayerVeterancy = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill;
	}
	else
	{
		PlayerVeterancy = class'KFVeterancyTypes';
	}

	KFPRI = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

	//Grab the perk's weapons first
	for ( j = 0; j < KFLR.MAX_BUYITEMS; j++ )
    {
    	if ( KFLR.ItemForSale[j] != none )
        {
			//Let's see if this is a vest, first aid kit, ammo or stuff we already have
			if ( class<Vest>(KFLR.ItemForSale[j]) != none || class<FirstAidKit>(KFLR.ItemForSale[j]) != none ||
                 class<KFWeapon>(KFLR.ItemForSale[j].default.InventoryType) == none || KFLR.ItemForSale[j].IsA('Ammunition') ||
				 class<KFWeapon>(KFLR.ItemForSale[j].default.InventoryType).default.bKFNeverThrow ||
                 IsInInventory(KFLR.ItemForSale[j]) ||
				 class<KFWeaponPickup>(KFLR.ItemForSale[j]).default.CorrespondingPerkIndex != PlayerVeterancy.default.PerkIndex)
        	{
        		continue;
			}

            if ( class<Deagle>(KFLR.ItemForSale[j].default.InventoryType) != none )
            {
				if ( IsInInventory(class'DualDeaglePickup') )
				{
					continue;
				}
			}

			if ( class<DualDeagle>(KFLR.ItemForSale[j].default.InventoryType) != none )
            {
				if ( IsInInventory(class'DeaglePickup') )
				{
					DualDivider = 2;
					bZeroWeight = true;
				}
			}
			else
			{
				DualDivider = 1;
				bZeroWeight = false;
			}

			if ( ForSaleArrayIndex >= ForSaleBuyables.Length )
			{
				ForSaleBuyable = new class'GUIBuyable';
				ForSaleBuyables[ForSaleBuyables.Length] = ForSaleBuyable;
			}
			else
			{
				ForSaleBuyable = ForSaleBuyables[ForSaleArrayIndex];
			}

			ForSaleArrayIndex++;

			ForSalePickup =  class<KFWeaponPickup>(KFLR.ItemForSale[j]);

   			ForSaleBuyable.ItemName 		= ForSalePickup.default.ItemName;
    		ForSaleBuyable.ItemDescription 	= ForSalePickup.default.Description;
    		ForSaleBuyable.ItemCategorie	= KFLR.EquipmentCategories[i].EquipmentCategoryName;
			ForSaleBuyable.ItemImage		= class<KFWeapon>(ForSalePickup.default.InventoryType).default.TraderInfoTexture;
			ForSaleBuyable.ItemWeaponClass	= class<KFWeapon>(ForSalePickup.default.InventoryType);
			ForSaleBuyable.ItemAmmoClass	= class<KFWeapon>(ForSalePickup.default.InventoryType).default.FireModeClass[0].default.AmmoClass;
			ForSaleBuyable.ItemPickupClass	= ForSalePickup;
			ForSaleBuyable.ItemCost			= int((float(ForSalePickup.default.Cost)
										  	  * PlayerVeterancy.static.GetCostScaling(KFPRI, ForSalePickup)) / DualDivider);
			ForSaleBuyable.ItemAmmoCost		= 0;
			ForSaleBuyable.ItemFillAmmoCost	= 0;

			if ( bZeroWeight)
			{
				ForSaleBuyable.ItemWeight 	= 0.f;
			}
			else
			{
				ForSaleBuyable.ItemWeight	= ForSalePickup.default.Weight;
			}

			ForSaleBuyable.ItemPower		= ForSalePickup.default.PowerValue;
			ForSaleBuyable.ItemRange		= ForSalePickup.default.RangeValue;
			ForSaleBuyable.ItemSpeed		= ForSalePickup.default.SpeedValue;
			ForSaleBuyable.ItemAmmoCurrent	= 0;
			ForSaleBuyable.ItemAmmoMax		= 0;
			ForSaleBuyable.ItemPerkIndex	= ForSalePickup.default.CorrespondingPerkIndex;

			// Make sure we mark the list as a sale list
			ForSaleBuyable.bSaleList = true;

			bZeroWeight = false;
		}
	}

	// now the rest
	for ( j = KFLR.MAX_BUYITEMS - 1; j >= 0; j-- )
    {
    	if ( KFLR.ItemForSale[j] != none )
        {
        	//Let's see if this is a vest, first aid kit, ammo or stuff we already have
            if ( class<Vest>(KFLR.ItemForSale[j]) != none || class<FirstAidKit>(KFLR.ItemForSale[j]) != none ||
                 class<KFWeapon>(KFLR.ItemForSale[j].default.InventoryType) == none || KFLR.ItemForSale[j].IsA('Ammunition') ||
				 class<KFWeapon>(KFLR.ItemForSale[j].default.InventoryType).default.bKFNeverThrow ||
                 IsInInventory(KFLR.ItemForSale[j]) ||
				 class<KFWeaponPickup>(KFLR.ItemForSale[j]).default.CorrespondingPerkIndex == PlayerVeterancy.default.PerkIndex )
        	{
        		continue;
			}

            if ( class<Deagle>(KFLR.ItemForSale[j].default.InventoryType) != none )
            {
				if ( IsInInventory(class'KFCommBeta.KFCBDualDeaglePickup') )
				{
					continue;
				}
			}

			if ( class<DualDeagle>(KFLR.ItemForSale[j].default.InventoryType) != none )
            {
				if ( IsInInventory(class'KFCommBeta.KFCBDeaglePickup') )
				{
					DualDivider = 2;
					bZeroWeight = true;
				}
			}
			else
			{
				DualDivider = 1;
				bZeroWeight = false;
			}

			if ( ForSaleArrayIndex >= ForSaleBuyables.Length )
			{
				ForSaleBuyable = new class'GUIBuyable';
				ForSaleBuyables[ForSaleBuyables.Length] = ForSaleBuyable;
			}
			else
			{
				ForSaleBuyable = ForSaleBuyables[ForSaleArrayIndex];
			}

			ForSaleArrayIndex++;

			ForSalePickup =  class<KFWeaponPickup>(KFLR.ItemForSale[j]);

   			ForSaleBuyable.ItemName 		= ForSalePickup.default.ItemName;
    		ForSaleBuyable.ItemDescription 	= ForSalePickup.default.Description;
    		ForSaleBuyable.ItemCategorie	= KFLR.EquipmentCategories[i].EquipmentCategoryName;

    		if ( class<KFWeapon>(ForSalePickup.default.InventoryType) != none )
    		{
				ForSaleBuyable.ItemImage		= class<KFWeapon>(ForSalePickup.default.InventoryType).default.TraderInfoTexture;
				ForSaleBuyable.ItemWeaponClass	= class<KFWeapon>(ForSalePickup.default.InventoryType);
				ForSaleBuyable.ItemAmmoClass	= class<KFWeapon>(ForSalePickup.default.InventoryType).default.FireModeClass[0].default.AmmoClass;
			}

			ForSaleBuyable.ItemPickupClass	= ForSalePickup;
			ForSaleBuyable.ItemCost			= int((float(ForSalePickup.default.Cost)
										  	  * PlayerVeterancy.static.GetCostScaling(KFPRI, ForSalePickup)) / DualDivider);
			ForSaleBuyable.ItemAmmoCost		= 0;
			ForSaleBuyable.ItemFillAmmoCost	= 0;

			if ( bZeroWeight)
			{
				ForSaleBuyable.ItemWeight 	= 0.f;
			}
			else
			{
				ForSaleBuyable.ItemWeight	= ForSalePickup.default.Weight;
			}

			ForSaleBuyable.ItemPower		= ForSalePickup.default.PowerValue;
			ForSaleBuyable.ItemRange		= ForSalePickup.default.RangeValue;
			ForSaleBuyable.ItemSpeed		= ForSalePickup.default.SpeedValue;
			ForSaleBuyable.ItemAmmoCurrent	= 0;
			ForSaleBuyable.ItemAmmoMax		= 0;
			ForSaleBuyable.ItemPerkIndex	= ForSalePickup.default.CorrespondingPerkIndex;

			// Make sure we mark the list as a sale list
			ForSaleBuyable.bSaleList = true;

			bZeroWeight = false;
		}
	}

	if ( ForSaleArrayIndex < ForSaleBuyables.Length )
	{
		ForSaleBuyables.Remove(ForSaleArrayIndex, ForSaleBuyables.Length);
	}

	//Now Update the list
	UpdateList();
}

