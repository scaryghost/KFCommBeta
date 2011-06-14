class KFCBZombieStalker extends ZombieStalker;

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

simulated function Tick(float DeltaTime) {
    super.Tick(DeltaTime);
    // Keep the stalker moving toward its target when attacking
    if( Role == ROLE_Authority && bShotAnim && !bWaitForAnim ) {
        if( LookTarget!=None ) {
            Acceleration = AccelRate * Normal(LookTarget.Location - Location);
        }
    }
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

function RangedAttack(Actor A) {
    if ( bShotAnim || Physics == PHYS_Swimming)
        return;
    else if ( CanAttack(A) ) {
        bShotAnim = true;
        SetAnimAction('ClawAndMove');
        return;
    }
}

// Overridden to handle playing upper body only attacks when moving
simulated event SetAnimAction(name NewAction) {
    if( NewAction=='' )
        Return;

    ExpectingChannel = AttackAndMoveDoAnimAction(NewAction);

    bWaitForAnim= false;

    if( Level.NetMode!=NM_Client ) {
        AnimAction = NewAction;
        bResetAnimAct = True;
        ResetAnimActTime = Level.TimeSeconds+0.3;
    }
}


// Handle playing the anim action on the upper body only if we're attacking and moving
simulated function int AttackAndMoveDoAnimAction( name AnimName ) {
    local int meleeAnimIndex;
    local float duration;

    if( AnimName == 'ClawAndMove' ) {
        meleeAnimIndex = Rand(3);
        AnimName = meleeAnims[meleeAnimIndex];
        CurrentDamtype = ZombieDamType[meleeAnimIndex];

        duration= GetAnimDuration(AnimName, 1.0);
    }

    if( AnimName=='StalkerSpinAttack' || AnimName=='StalkerAttack1' || AnimName=='JumpAttack') {
        AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
        PlayAnim(AnimName,, 0.1, 1);

        return 1;
    }

    return super.DoAnimAction( AnimName );
}

defaultproperties {
    MenuName= "KFCommBeta Stalker"
}
