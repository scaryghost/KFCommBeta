class KFCBZombieStalker extends ZombieStalker;

function float NumPlayersHealthModifer() {
    return class'KFCBAux'.static.healthModifier(super.NumPlayersHealthModifer(),PlayerCountHealthScale);
}

function float NumPlayersHeadHealthModifer() {
    return class'KFCBAux'.static.healthModifier(super.NumPlayersHeadHealthModifer(),PlayerNumHeadHealthScale);
}

function float DifficultyDamageModifer() {
    return class'KFCBAux'.static.DifficultyDamageModifer(Level.Game.GameDifficulty,Level.Game.NumPlayers);
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
