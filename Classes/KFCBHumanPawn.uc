class KFCBHumanPawn extends KFHumanPawn;

simulated event ModifyVelocity(float DeltaTime, vector OldVelocity) {
    local float WeightMod, HealthMod;
    local float EncumbrancePercentage;

    super(KFPawn).ModifyVelocity(DeltaTime, OldVelocity);

    if (Controller != none) {

        /**
         *  Calculates the speed from carry weight
         *  Wave 3:
         *      Changed the calculation to be based on max default carry weight, 
         *      not the perked max carry weight. Support carrying 24/24 will move 
         *      slower than a perk at 15/15.
         */        
        EncumbrancePercentage = (FMin(CurrentWeight, MaxCarryWeight)/default.MaxCarryWeight);

        WeightMod = (1.0 - (EncumbrancePercentage * WeightSpeedModifier));
        HealthMod = ((Health/HealthMax) * HealthSpeedModifier) + (1.0 - HealthSpeedModifier);

        // Apply all the modifiers
        GroundSpeed = default.GroundSpeed * HealthMod;
        GroundSpeed *= WeightMod;
        GroundSpeed += InventorySpeedModifier;

        if ( KFPlayerReplicationInfo(PlayerReplicationInfo) != none && KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill != none )
        {
            GroundSpeed *= KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill.static.GetMovementSpeedModifier(KFPlayerReplicationInfo(PlayerReplicationInfo));
        }
        log("Ground speed: "$GroundSpeed);
    }
}

