class KFCBZombieSiren extends ZombieSiren;

function float healthModifier(float healthScale) {
    local float originalHealthModifier;
    local float newHealthModifier;

    originalHealthModifier= super.NumPlayersHealthModifer();
    newHealthModifier= 1.0 + (class'KFCBMutator'.default.minNumPlayers - 1) * healthScale;

    if (originalHealthModifier < newHealthModifier) {
        return newHealthModifier;
    }
    return originalHealthModifier;

}

function float NumPlayersHealthModifer() {
    return healthModifier(PlayerCountHealthScale);
}

function float NumPlayersHeadHealthModifer() {
    return healthModifier(PlayerNumHeadHealthScale);
}

function float DifficultyDamageModifer() {
    local float AdjustedDamageModifier;

    if ( Level.Game.GameDifficulty >= 7.0 ) { // Hell on Earth
        AdjustedDamageModifier = 1.75;
    }
    else if ( Level.Game.GameDifficulty >= 5.0 ) {// Suicidal
        AdjustedDamageModifier = 1.50;
    }
    else if ( Level.Game.GameDifficulty >= 4.0 ) {// Hard
        AdjustedDamageModifier = 1.25;
    }
    else if ( Level.Game.GameDifficulty >= 2.0 ) {// Normal
        AdjustedDamageModifier = 1.0;
    }
    else { //if ( GameDifficulty == 1.0 ) // Beginner
        AdjustedDamageModifier = 0.3;
    }

    // Do less damage if we're alone
    if( Level.Game.NumPlayers == 1 && 
        class'KFCBMutator'.default.minNumPlayers <= 1) {
        AdjustedDamageModifier *= 0.75;
    }

    return AdjustedDamageModifier;
}

simulated function Timer() {
    bSTUNNED = false;
    if (BurnDown > class'KFCBMutator'.default.burnDownEnd) {
        if (FireDamageClass == class'DamTypeFlamethrower') {
            TakeFireDamage(LastBurnDamage + rand(2) + class'KFCBMutator'.default.flameThrowerIncr , LastDamagedBy);
        } else {
            TakeFireDamage(LastBurnDamage + rand(2) + class'KFCBMutator'.default.MAC10Incr , LastDamagedBy);
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

    if ( BurnDown > class'KFCBMutator'.default.burnDownEnd ) {
        BurnDown --;
    }

    if ( BurnDown < CrispUpThreshhold ) {
        ZombieCrispUp();
    }

    if ( BurnDown == class'KFCBMutator'.default.burnDownEnd ) {
        bBurnified = false;
        GroundSpeed = default.GroundSpeed;
    }
}

defaultproperties {
    /**
     *  Appropriately scale panic tick
     *  Wave 4:
     *      Set to 8, with only 8 second burn time 
     */
    CrispUpThreshhold= 8

    MenuName= "KCommBeta Siren"
}
