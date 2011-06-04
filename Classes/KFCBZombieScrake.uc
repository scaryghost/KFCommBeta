class KFCBZombieScrake extends ZombieScrake;

simulated function Timer() {
    bSTUNNED = false;
    /**
     *  Alter burn behavior.  Originally is 10 seconds of burn time
     *  Wave 4:
     *      Reduce burn time to 8 seconds, increase flame damage by 20%
     */
    if (BurnDown > 2)
        TakeFireDamage(LastBurnDamage + rand(2) + 3 , LastDamagedBy);
    else {
        //Reset burndown variable back to 0 to TakeDamage knows to 
        //re-initialize the timer
        BurnDown= 0;
        UnSetBurningBehavior();

        RemoveFlamingEffects();
        StopBurnFX();
        SetTimer(0, false);
    }
}

function TakeFireDamage(int Damage,pawn Instigator) {
    local Vector DummyHitLoc,DummyMomentum;

    TakeDamage(Damage, BurnInstigator, DummyHitLoc, DummyMomentum, FireDamageClass);

    if ( BurnDown > 2 ) {
        // Decrement the number of FireDamage calls left before our Zombie is extinguished :)
        BurnDown --;
    }

    // Melt em' :)
    if ( BurnDown < CrispUpThreshhold ) {
        ZombieCrispUp();
    }

    if ( BurnDown == 2 ) {
        bBurnified = false;
        GroundSpeed = default.GroundSpeed;
    }
}

defaultproperties {
    /**
     *  Appropriately scale panic tick
     *  Wave 4:
     *      Set to 6, with only 8 second burn time 
     */
    CrispUpThreshhold= 6
}
