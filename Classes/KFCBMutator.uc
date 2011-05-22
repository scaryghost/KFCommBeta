class KFCBMutator extends Mutator;

function PostBeginPlay() {
    local KFGameType KF;

	KF = KFGameType(Level.Game);
  	if (Level.NetMode != NM_Standalone)
		AddToPackageMap("KFCommBeta");

	if (KF == none) {
		Destroy();
		return;
	}

	SetTimer(0.1, false);
}

function Timer() {
	Destroy();
}

function betaWave2() {
    //Increase EBR hs multiplier by 0.05
    class'DamTypeM14EBR'.default.HeadShotDamageMult= 2.30;
    
    //Replace the base arrow with our modded arrow
    class'CrossbowFire'.default.ProjectileClass= class'KFCBCrossbowArrow';
}

defaultproperties {
	GroupName="KF"
	FriendlyName="KF Community Beta"
	Description="Loads the suggestions given by the community.  This version in is 1.0"
}
