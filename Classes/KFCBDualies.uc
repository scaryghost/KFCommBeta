class KFCBDualies extends Dualies;

function DropFrom(vector StartLocation)
{
    local int m;
    local Pickup Pickup;
    local Inventory I;
    local int AmmoThrown,OtherAmmo;

    if( !bCanThrow )
        return;

    AmmoThrown = AmmoAmount(0);
    ClientWeaponThrown();

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m].bIsFiring)
            StopFire(m);
    }

    if ( Instigator != None )
        DetachFromPawn(Instigator);

    if( Instigator.Health>0 )
    {
        OtherAmmo = AmmoThrown/2;
        AmmoThrown-=OtherAmmo;
        I = Spawn(Class'KFCommBeta.KFCBSingle');
        I.GiveTo(Instigator);
        Weapon(I).Ammo[0].AmmoAmount = OtherAmmo;
        Single(I).MagAmmoRemaining = MagAmmoRemaining/2;
        MagAmmoRemaining = Max(MagAmmoRemaining-Single(I).MagAmmoRemaining,0);
    }
    Pickup = Spawn(PickupClass,,, StartLocation);
    if ( Pickup != None )
    {
        Pickup.InitDroppedPickupFor(self);
        Pickup.Velocity = Velocity;
        WeaponPickup(Pickup).AmmoAmount[0] = AmmoThrown;
        if( KFWeaponPickup(Pickup)!=None )
            KFWeaponPickup(Pickup).MagAmmoRemaining = MagAmmoRemaining;
        if (Instigator.Health > 0)
            WeaponPickup(Pickup).bThrown = true;
    }

    Destroyed();
    Destroy();
}

defaultproperties {
    PickupClass=class'KFCommBeta.KFCBDualiesPickup'
    ItemNAme="KFCommBeta Dual 9mms"
}
