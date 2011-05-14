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

defaultproperties {
	GroupName="KF"
	FriendlyName="KF Community Beta"
	Description="Loads the suggestions given by the community.  This version in is 1.0"
}
