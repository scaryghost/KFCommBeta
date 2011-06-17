class KFCBZombieFleshpound extends ZombieFleshpound;

var int totalDamageRageThreshold;
var int totalRageAccumulator;

function float NumPlayersHealthModifer() {
    return class'KFCBAux'.static.healthModifier(super.NumPlayersHealthModifer(),PlayerCountHealthScale);
}

function float NumPlayersHeadHealthModifer() {
    return class'KFCBAux'.static.healthModifier(super.NumPlayersHeadHealthModifer(),PlayerNumHeadHealthScale);
}

function float DifficultyDamageModifer() {
    return class'KFCBAux'.static.DifficultyDamageModifer(Level.Game.GameDifficulty,Level.Game.NumPlayers);
}

simulated function PostNetBeginPlay() {
    super.PostNetBeginPlay();
    totalRageAccumulator= 0;
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

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex) {
    local int oldHealth;

    oldHealth= Health;
    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);
    totalRageAccumulator+= (oldHealth - Health);

	if (!isInState('BeginRaging') && !bDecapitated && 
        totalRageAccumulator >= totalDamageRageThreshold && 
        !bChargingPlayer && (!(bCrispified && bBurnified) || bFrustrated) ) {
        totalRageAccumulator= 0;
        StartCharging();
    }
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir) {
    local bool didIHit;
    
    didIHit= super.MeleeDamageTarget(hitdamage, pushdir);
    KFCBFleshPoundZombieController(Controller).bMissTarget= 
        KFCBFleshPoundZombieController(Controller).bMissTarget || !didIHit;
    return didIHit;
}

defaultproperties {
    MenuName= "KFCommBeta Fleshpound"

    /**
     *  Appropriately scale panic tick
     *  Wave 4:
     *      Set to 6, with only 8 second burn time 
     */
    CrispUpThreshhold= 6

    /**
     *  Add new rage condition.  Use a total damage accumulator 
     *  in addition to the 2 second accumulator
     *  Wave 4:
     *      Set to 1710, which is equal to 5 alt fire axe head shots
     */
    totalDamageRageThreshold= 1710

    ControllerClass=class'KFCommBeta.KFCBFleshPoundZombieController'
}
