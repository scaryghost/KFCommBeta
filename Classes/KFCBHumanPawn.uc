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
            GroundSpeed *= KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill.static.GetMovementSpeedModifier(KFPlayerReplicationInfo(PlayerReplicationInfo));
        }
    }
}

function ServerBuyWeapon( Class<Weapon> WClass ) {
    local Inventory I, J;
    local float Price;

    if( !CanBuyNow() || Class<KFWeapon>(WClass)==None || Class<KFWeaponPickup>(WClass.Default.PickupClass)==None ) {
        Return;
    }

    Price = class<KFWeaponPickup>(WClass.Default.PickupClass).Default.Cost;

    if ( KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill != none ) {
        Price *= KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(PlayerReplicationInfo), WClass.Default.PickupClass);
    }

    for ( I=Inventory; I!=None; I=I.Inventory ) {
        if( I.Class==WClass )
        {
            Return; // Already has weapon.
        }
    }

    if ( WClass == class'KFCommBeta.KFCBDualDeagle' ) {
        for ( J = Inventory; J != None; J = J.Inventory ) {
            if ( J.class == class'KFCommBeta.KFCBDeagle' ) {
                Price = Price / 2;
                bHasDeagle = true;
                break;
            }
        }
    }

    if ( !bHasDeagle && !CanCarry(Class<KFWeapon>(WClass).Default.Weight) ) {
        bHasDeagle = false;
        Return;
    }

    if ( PlayerReplicationInfo.Score < Price ) {
        bHasDeagle = false;
        Return; // Not enough CASH.
    }

    I = Spawn(WClass);

    if ( I != none ) {
        KFWeapon(I).UpdateMagCapacity(PlayerReplicationInfo);
        KFWeapon(I).FillToInitialAmmo();
        KFWeapon(I).SellValue = Price * 0.75;
        I.GiveTo(self);
        PlayerReplicationInfo.Score -= Price;

        ClientForceChangeWeapon(I);
    }

    bHasDeagle = false;

    SetTraderUpdate();
}


function ServerSellWeapon( Class<Weapon> WClass ) {
    local Inventory I;
    local Single NewSingle;
    local Deagle NewDeagle;
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

            if ( Dualies(I) != none && DualDeagle(I) == none ) {
                NewSingle = Spawn(class'KFCommBeta.KFCBSingle');
                NewSingle.GiveTo(self);
            }

            if ( DualDeagle(I) != none ) {
                NewDeagle = Spawn(class'KFCommBeta.KFCBDeagle');
                NewDeagle.GiveTo(self);
                Price = Price / 2;
            }

            if ( I == Weapon || I == PendingWeapon ) {
                ClientCurrentWeaponSold();
            }

            PlayerReplicationInfo.Score += Price;

            I.Destroyed();
            I.Destroy();

            SetTraderUpdate();

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

