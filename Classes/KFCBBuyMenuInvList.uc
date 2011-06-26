class KFCBBuyMenuInvList extends SRKFBuyMenuInvList;

function UpdateMyBuyables()
{
	local GUIBuyable MyBuyable, KnifeBuyable, FragBuyable;
	local Inventory CurInv;
	local KFLevelRules KFLR;
	local bool bHasDual, bHasDualCannon;
	local float CurAmmo, MaxAmmo;
	local class<KFWeaponPickup> MyPickup;
	local int DualDivider, NumInvItems;

	//Let's start with our current inventory
	if ( PlayerOwner().Pawn.Inventory == none )
	{
		log("Inventory is none!");
		return;
	}

	DualDivider = 1;
	AutoFillCost = 0.00000;

	//Clear the MyBuyables array
	CopyAllBuyables();
	MyBuyables.Length = 0;

	//Check if we have dualies or dual hand cannons
	for ( CurInv = PlayerOwner().Pawn.Inventory; CurInv != none; CurInv = CurInv.Inventory )
	{
		if ( KFWeapon(CurInv) != none )
		{
			if ( KFWeapon(CurInv).default.PickupClass == class'KFCommBeta.KFCBDualDeaglePickup' )
				bHasDualCannon = true;
			if ( KFWeapon(CurInv).default.PickupClass == class'KFCommBeta.KFCBDualiesPickup' )
				bHasDual = true;
		}
	}

	// Grab the items for sale, we need the categories
	foreach PlayerOwner().DynamicActors(class'KFLevelRules', KFLR)
		break;

	// Fill the Buyables
	NumInvItems = 0;
	for ( CurInv = PlayerOwner().Pawn.Inventory; CurInv != none; CurInv = CurInv.Inventory )
	{
		if ( CurInv.IsA('Ammunition') || CurInv.IsA('Welder') || CurInv.IsA('Syringe') )
			continue;

		if ( CurInv.IsA('KFCBDualDeagle') )
			DualDivider = 2;
		else DualDivider = 1;

		MyPickup = class<KFWeaponPickup>(KFWeapon(CurInv).default.PickupClass);

		// if we already own dualies, we do not need the single 9mm in the list
		if ( (bHasDual && MyPickup == class'KFCommBeta.KFCBSinglePickup') || (bHasDualCannon && MyPickup == class'KFCommBeta.KFCBDeaglePickup') )
			continue;

		if ( CurInv.IsA('KFWeapon') )
		{
			KFWeapon(CurInv).GetAmmoCount(MaxAmmo, CurAmmo);

			MyBuyable = AllocateEntry();

			MyBuyable.ItemName 		= MyPickup.default.ItemShortName;
			MyBuyable.ItemDescription 	= KFWeapon(CurInv).default.Description;
			MyBuyable.ItemCategorie		= KFLR.EquipmentCategories[MyPickup.default.EquipmentCategoryID].EquipmentCategoryName;
			MyBuyable.ItemImage		= KFWeapon(CurInv).default.TraderInfoTexture;
			MyBuyable.ItemWeaponClass	= KFWeapon(CurInv).class;
			MyBuyable.ItemAmmoClass		= KFWeapon(CurInv).default.FireModeClass[0].default.AmmoClass;
			MyBuyable.ItemPickupClass	= MyPickup;
			MyBuyable.ItemCost		= (float(MyPickup.default.Cost) * KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo), MyPickup)) / DualDivider;
			MyBuyable.ItemAmmoCost		= MyPickup.default.AmmoCost * KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill.static.GetAmmoCostScaling(KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo), MyPickup)
										  * KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill.static.GetMagCapacityMod(KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo), KFWeapon(CurInv));
			MyBuyable.ItemFillAmmoCost	= (int(((MaxAmmo - CurAmmo) * float(MyPickup.default.AmmoCost)) / float(KFWeapon(CurInv).default.MagCapacity))) * KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill.static.GetAmmoCostScaling(KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo), MyPickup);
			MyBuyable.ItemWeight		= KFWeapon(CurInv).Weight;
			MyBuyable.ItemPower		= MyPickup.default.PowerValue;
			MyBuyable.ItemRange		= MyPickup.default.RangeValue;
			MyBuyable.ItemSpeed		= MyPickup.default.SpeedValue;
			MyBuyable.ItemAmmoCurrent	= CurAmmo;
			MyBuyable.ItemAmmoMax		= MaxAmmo;

            /**
             *  Had to change this line to use the bMeleeWeapon variable
             *  so the Chainsaw's ammo would show up on the ammo list 
             */
			MyBuyable.bMelee			= KFWeapon(CurInv).bMeleeWeapon;

			MyBuyable.bSaleList		= false;
			MyBuyable.ItemPerkIndex		= MyPickup.default.CorrespondingPerkIndex;

			if ( KFWeapon(CurInv) != none && KFWeapon(CurInv).SellValue != -1 )
				MyBuyable.ItemSellValue = KFWeapon(CurInv).SellValue;
			else MyBuyable.ItemSellValue = MyBuyable.ItemCost * 0.75;

			if ( !MyBuyable.bMelee && int(MaxAmmo) > int(CurAmmo))
				AutoFillCost += MyBuyable.ItemFillAmmoCost;

			if ( CurInv.IsA('Knife') )
			{
				MyBuyable.bSellable	= false;
				KnifeBuyable = MyBuyable;
			}
			else if ( CurInv.IsA('Frag') )
			{
				MyBuyable.bSellable	= false;
				FragBuyable = MyBuyable;
			}
			else if ( NumInvItems < 7 )
			{
				MyBuyable.bSellable	= !KFWeapon(CurInv).default.bKFNeverThrow;
				MyBuyables.Insert(0,1);
				MyBuyables[0] = MyBuyable;
				NumInvItems++;
			}
		}
	}

	MyBuyable = AllocateEntry();

	MyBuyable.ItemName 		= class'BuyableVest'.default.ItemName;
	MyBuyable.ItemDescription 	= class'BuyableVest'.default.ItemDescription;
	MyBuyable.ItemCategorie		= "";
	MyBuyable.ItemImage		= class'BuyableVest'.default.ItemImage;
	MyBuyable.ItemAmmoCurrent	= PlayerOwner().Pawn.ShieldStrength;
	MyBuyable.ItemAmmoMax		= 100;
	MyBuyable.ItemCost		= int(class'BuyableVest'.default.ItemCost * KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo), class'Vest'));
	MyBuyable.ItemAmmoCost		= MyBuyable.ItemCost / 100;
	MyBuyable.ItemFillAmmoCost	= int((100.0 - MyBuyable.ItemAmmoCurrent) * MyBuyable.ItemAmmoCost);
	MyBuyable.bIsVest			= true;
	MyBuyable.bMelee			= false;
	MyBuyable.bSaleList		= false;
	MyBuyable.bSellable		= false;
	MyBuyable.ItemPerkIndex		= class'BuyableVest'.default.CorrespondingPerkIndex;

	if( MyBuyables.Length<8 )
	{
		MyBuyables.Length = 11;
		MyBuyables[7] = none;
		MyBuyables[8] = KnifeBuyable;
		MyBuyables[9] = FragBuyable;
		MyBuyables[10] = MyBuyable;
	}
	else
	{
		MyBuyables[MyBuyables.Length] = none;
		MyBuyables[MyBuyables.Length] = KnifeBuyable;
		MyBuyables[MyBuyables.Length] = FragBuyable;
		MyBuyables[MyBuyables.Length] = MyBuyable;
	}

	//Now Update the list
	UpdateList();
}

