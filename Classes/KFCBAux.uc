class KFCBAux extends Object;

static function float healthModifier(float originalHealthModifier, float healthScale) {
    local float newHealthModifier;

    newHealthModifier= 1.0 + (class'KFCBMutator'.default.minNumPlayers - 1) * healthScale;

    if (originalHealthModifier < newHealthModifier) {
        return newHealthModifier;
    }
    return originalHealthModifier;

}

static function float DifficultyDamageModifer(int difficulty, int numPlayers) {
    local float AdjustedDamageModifier;

    if ( difficulty >= 7.0 ) { // Hell on Earth
        AdjustedDamageModifier = 1.75;
    }
    else if ( difficulty >= 5.0 ) {// Suicidal
        AdjustedDamageModifier = 1.50;
    }
    else if ( difficulty >= 4.0 ) {// Hard
        AdjustedDamageModifier = 1.25;
    }
    else if ( difficulty >= 2.0 ) {// Normal
        AdjustedDamageModifier = 1.0;
    }
    else { //if ( GameDifficulty == 1.0 ) // Beginner
        AdjustedDamageModifier = 0.3;
    }

    // Do less damage if we're alone
    if( numPlayers == 1 && 
        class'KFCBMutator'.default.minNumPlayers <= 1) {
        AdjustedDamageModifier *= 0.75;
    }

    return AdjustedDamageModifier;
}


