class KFCBCrossbowArrow extends CrossbowArrow;

var float arrowDmgScale;
/**
 *  Code is copied from CrossbowArrow.
 */
simulated function ProcessTouch (Actor Other, vector HitLocation) {
    local vector X,End,HL,HN;
    local Vector TempHitLocation, HitNormal;
    local array<int>    HitPoints;
    local KFPawn HitPawn;
    local bool  bHitWhipAttachment;

    if ( Other == none || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces || Other==IgnoreImpactPawn ||
        (IgnoreImpactPawn != none && Other.Base == IgnoreImpactPawn) )
        return;

    X =  Vector(Rotation);

    if( ROBulletWhipAttachment(Other) != none ) {
        bHitWhipAttachment=true;
        if(!Other.Base.bDeleteMe) {
            Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535 * X), HitPoints, HitLocation,, 1);

            if( Other == none || HitPoints.Length == 0 )
                return;

            HitPawn = KFPawn(Other);

            if (Role == ROLE_Authority) {
                if ( HitPawn != none ) {
                    if( !HitPawn.bDeleteMe )
                        HitPawn.ProcessLocationalDamage(Damage, Instigator, TempHitLocation, MomentumTransfer * X, MyDamageType,HitPoints);
                    Damage*= arrowDmgScale;
                    Velocity*=0.85;

                    IgnoreImpactPawn = HitPawn;

                    if( Level.NetMode!=NM_Client )
                        PlayhitNoise(Pawn(Other)!=none && Pawn(Other).ShieldStrength>0);

                     return;
                }
            }
        }
        else {
            return;
        }
    }

    if( Level.NetMode!=NM_Client )
        PlayhitNoise(Pawn(Other)!=none && Pawn(Other).ShieldStrength>0);

    if( Physics==PHYS_Projectile && Pawn(Other)!=None && Vehicle(Other)==None ) {
        IgnoreImpactPawn = Pawn(Other);
        if( IgnoreImpactPawn.IsHeadShot(HitLocation, X, 1.0) )
            Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * X, DamageTypeHeadShot);
        else Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
        Damage*= arrowDmgScale;
        Velocity*=0.85;
        Return;
    }
    else if( ExtendedZCollision(Other)!=None && Pawn(Other.Owner)!=None ) {
        if( Other.Owner==IgnoreImpactPawn )
            Return;
        IgnoreImpactPawn = Pawn(Other.Owner);
        if ( IgnoreImpactPawn.IsHeadShot(HitLocation, X, 1.0))
            Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * X, DamageTypeHeadShot);
        else Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
        Damage*= arrowDmgScale;
        Velocity*=0.85;
        Return;
    }
    if( Level.NetMode!=NM_DedicatedServer && SkeletalMesh(Other.Mesh)!=None && Other.DrawType==DT_Mesh && Pawn(Other)!=None ) { // Attach victim to the wall behind if it dies.
        End = Other.Location+X*600;
        if( Other.Trace(HL,HN,End,Other.Location,False)!=None )
            Spawn(Class'BodyAttacher',Other,,HitLocation).AttachEndPoint = HL-HN;
    }
    Stick(Other,HitLocation);
    if( Level.NetMode!=NM_Client ) {
        if (Pawn(Other) != none && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
            Pawn(Other).TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * X, DamageTypeHeadShot);
        else Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
    }
}

defaultproperties {
    /**
     *  Original value: 0.8 (1/1.25 = 0.8)
     *  Wave 2: 0.5
     */
    arrowDmgScale= 0.5

    /**
     *  Original value: 300
     *  Wave 2: 325
     */
    Damage= 325
}

