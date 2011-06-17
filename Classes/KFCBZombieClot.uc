class KFCBZombieClot extends ZombieClot;

function float NumPlayersHealthModifer() {
    return class'KFCBAux'.static.healthModifier(super.NumPlayersHealthModifer(),PlayerCountHealthScale);
}

function float NumPlayersHeadHealthModifer() {
    return class'KFCBAux'.static.healthModifier(super.NumPlayersHeadHealthModifer(),PlayerNumHeadHealthScale);
}

function float DifficultyDamageModifer() {
    return class'KFCBAux'.static.DifficultyDamageModifer(Level.Game.GameDifficulty,Level.Game.NumPlayers);
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
    MenuName= "KFCommBeta Clot"
}
