class KFCBHumanPawn extends KFHumanPawn;

simulated event ModifyVelocity(float DeltaTime, vector OldVelocity) {
    local float WeightMod, HealthMod;
    local float EncumbrancePercentage;

    super(KFPawn).ModifyVelocity(DeltaTime, OldVelocity);

    if (Controller != none) {

        /**
         *  Calculates the speed from carry weight
         *  Wave 3:
         *      Changed the calculation to be based on max default carry weight, 
         *      not the perked max carry weight. Support carrying 24/24 will move 
         *      slower than a perk at 15/15.
         */        
        EncumbrancePercentage = (FMin(CurrentWeight, MaxCarryWeight)/default.MaxCarryWeight);

        WeightMod = (1.0 - (EncumbrancePercentage * WeightSpeedModifier));
        HealthMod = ((Health/HealthMax) * HealthSpeedModifier) + (1.0 - HealthSpeedModifier);

        // Apply all the modifiers
        GroundSpeed = default.GroundSpeed * HealthMod;
        GroundSpeed *= WeightMod;
        GroundSpeed += InventorySpeedModifier;

        if ( KFPlayerReplicationInfo(PlayerReplicationInfo) != none && KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill != none )
        {
            GroundSpeed *= KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill.static.GetMovementSpeedModifier(KFPlayerReplicationInfo(PlayerReplicationInfo), KFGameReplicationInfo(Level.GRI));
        }
    }
}

function ServerBuyWeapon( Class<Weapon> WClass ) {
    local Inventory I, J;
    local float Price;
    local bool bIsDualWeapon, bHasDual9mms, bHasDualHCs, bHasDualRevolvers;

    if( !CanBuyNow() || Class<KFWeapon>(WClass)==None || Class<KFWeaponPickup>(WClass.Default.PickupClass)==None ) {
        Return;
    }

    Price = class<KFWeaponPickup>(WClass.Default.PickupClass).Default.Cost;

    if ( KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill != none ) {
        Price *= KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(PlayerReplicationInfo), WClass.Default.PickupClass);
    }

    for ( I=Inventory; I!=None; I=I.Inventory ) {
        if( I.Class==WClass ) {
            Return; // Already has weapon.
        }

        if ( I.Class == class'KFCBDualies' ) {
            bHasDual9mms = true;
        }
        else if ( I.Class == class'KFCBDualDeagle' ) {
            bHasDualHCs = true;
        }
        else if ( I.Class == class'Dual44Magnum' ) {
            bHasDualRevolvers = true;
        }
    }

    if ( WClass == class'KFCBDualDeagle' ) {
        for ( J = Inventory; J != None; J = J.Inventory ) {
            if ( J.class == class'KFCBDeagle' ) {
                Price = Price / 2;
                bHasNonDefaultDualWeapon = true;

                break;
            }
        }

        bIsDualWeapon = true;
        bHasDualHCs = true;
    }

    if ( WClass == class'Dual44Magnum' ) {
        for ( J = Inventory; J != None; J = J.Inventory ) {
            if ( J.class == class'Magnum44Pistol' ) {
                Price = Price / 2;
                bHasNonDefaultDualWeapon = true;

                break;
            }
        }

        bIsDualWeapon = true;
        bHasDualRevolvers = true;
    }

    bIsDualWeapon = bIsDualWeapon || WClass == class'KFCBDualies';

    if ( !bHasNonDefaultDualWeapon && !CanCarry(Class<KFWeapon>(WClass).Default.Weight) ) {
        bHasNonDefaultDualWeapon = false;
        Return;
    }

    if ( PlayerReplicationInfo.Score < Price ) {
        bHasNonDefaultDualWeapon = false;
        Return; // Not enough CASH.
    }

    I = Spawn(WClass);

    if ( I != none ) {
        if ( KFGameType(Level.Game) != none ) {
            KFGameType(Level.Game).WeaponSpawned(I);
        }

        KFWeapon(I).UpdateMagCapacity(PlayerReplicationInfo);
        KFWeapon(I).FillToInitialAmmo();
        KFWeapon(I).SellValue = Price * 0.75;
        I.GiveTo(self);
        PlayerReplicationInfo.Score -= Price;

        if ( bIsDualWeapon ) {
            KFSteamStatsAndAchievements(PlayerReplicationInfo.SteamStatsAndAchievements).OnDualsAddedToInventory(bHasDual9mms, bHasDualHCs, bHasDualRevolvers);
        }

        ClientForceChangeWeapon(I);
    }

    bHasNonDefaultDualWeapon = false;

    SetTraderUpdate();
}

function ServerSellWeapon( Class<Weapon> WClass ) {
    local Inventory I;
    local Single NewSingle;
    local Deagle NewDeagle;
    local Magnum44Pistol New44Magnum;
    local float Price;

    if ( !CanBuyNow() || Class<KFWeapon>(WClass) == none || Class<KFWeaponPickup>(WClass.Default.PickupClass) == none ) {
        SetTraderUpdate();
        Return;
    }

    for ( I = Inventory; I != none; I = I.Inventory ) {
        if ( I.Class == WClass ) {
            if ( KFWeapon(I) != none && KFWeapon(I).SellValue != -1 ) {
                Price = KFWeapon(I).SellValue;
            }
            else {
                Price = int(class<KFWeaponPickup>(WClass.default.PickupClass).default.Cost * 0.75);

                if ( KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill != none ) {
                    Price *= KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(PlayerReplicationInfo), WClass.Default.PickupClass);
                }
            }

            if ( Dualies(I) != none && DualDeagle(I) == none && Dual44Magnum(I) == none ) {
                NewSingle = Spawn(class'KFCBSingle');
                NewSingle.GiveTo(self);
            }

            if ( DualDeagle(I) != none ) {
                NewDeagle = Spawn(class'KFCBDeagle');
                NewDeagle.GiveTo(self);
                Price = Price / 2;
            }

            if ( Dual44Magnum(I) != none ) {
                New44Magnum = Spawn(class'Magnum44Pistol');
                New44Magnum.GiveTo(self);
                Price = Price / 2;
            }

            if ( I == Weapon || I == PendingWeapon ) {
                ClientCurrentWeaponSold();
            }

            PlayerReplicationInfo.Score += Price;

            I.Destroyed();
            I.Destroy();

            SetTraderUpdate();

            if ( KFGameType(Level.Game) != none ) {
                KFGameType(Level.Game).WeaponDestroyed(WClass);
            }

            return;
        }
    }
}

defaultproperties {
    RequiredEquipment(0)="KFMod.Knife"
    RequiredEquipment(1)="KFCommBeta.KFCBSingle"
    RequiredEquipment(2)="KFMod.Frag"
    RequiredEquipment(3)="KFMod.Syringe"
    RequiredEquipment(4)="KFMod.Welder"
}

