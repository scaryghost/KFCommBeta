class KFCBZombieScrake extends ZombieScrake;

simulated function Timer() {
    bSTUNNED = false;
    /**
     *  Alter burn behavior.  Originally is 10 seconds of burn time
     *  Wave 4:
     *      - Reduce burn time to 8 seconds
     *      - Increase spacing between burn damages from [3,5] to [6.5,8.5] 
     *      - For MAC10, from [3,5] to [8,10] because specimens don't take 
     *        extra 1.5x damage from MAC10 DOT, new MAC10 DOT > old
     */
    if (BurnDown > 2) {
        if (FireDamageClass == class'DamTypeFlamethrower') {
            TakeFireDamage(LastBurnDamage + rand(2) + 6.5 , LastDamagedBy);
        } else {
            TakeFireDamage(LastBurnDamage + rand(2) + 8 , LastDamagedBy);
        }
    }
    else {
        //Reset burndown variable back to 0 so TakeDamage knows to 
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
        BurnDown --;
    }

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
