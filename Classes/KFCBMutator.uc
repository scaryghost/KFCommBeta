class KFCBMutator extends Mutator;

simulated function PostBeginPlay() {
    local KFGameType KF;

	KF = KFGameType(Level.Game);
  	if (Level.NetMode != NM_Standalone)
		AddToPackageMap("KFCommBeta");

	if (KF == none) {
		Destroy();
		return;
	}

    betaWave2();

	SetTimer(0.1, false);
}

function Timer() {
	Destroy();
}

function betaWave2() {
    /**
     *  Base EBR HS multiplier: 2.25 
     *  Wave 2: 2.30
     */
    class'KFMod.DamTypeM14EBR'.default.HeadShotDamageMult= 2.30;
    
    /**
     *  Replace the base arrow with our modded arrow.  See the KFCBCrossbowArrow
     *  class for beta specifics
     */
    class'CrossbowFire'.default.ProjectileClass= class'KFCBCrossbowArrow';


    /**
     *  Alter winchester pricing - original £200
     *  Wave 2: Upped to £400
     */
    class'WinchesterPickup'.default.cost= 400;

    /**
     *  Make the chainsaw more beastly
     *  Wave 2:
     *      Up the cost to 2500
     *      Up the damage to 22-27
     *      Decrease the slowdown rate to 0.20
     */
    class'ChainsawPickup'.default.cost= 2500;
    class'ChainsawFire'.default.damageConst= 22;
    class'Chainsaw'.default.ChopSlowRate= 0.20;

}

defaultproperties {
	GroupName="KFCommBeta"
	FriendlyName="KF Community Beta"
	Description="Loads the suggestions given by the community.  This version in is 1.1"
}
