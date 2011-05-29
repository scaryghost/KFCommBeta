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

    /**
     *  Overwrite the pawn with the beta pawn.  
     *  See the class for details.
     */
    KF.PlayerControllerClass= class'KFCommBeta.KFCBPlayerController';
    KF.PlayerControllerClassName= "KFCommBeta.KFCBPlayerController";

    ModifySharpWpn();
    ModifyZerkWpn();
    ModifyCommWpn();
    ModifyDemoWpn();

	SetTimer(0.1, false);
}

function Timer() {
	Destroy();
}

function ModifySharpWpn() {
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
}

function ModifyZerkWpn() {
    local int fuelAmount, clipAmount;

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

    /**
     *  Set up "fuel" for the chainsaw
     *  Wave 3:
     *      Cost:       £15 per 100 units
     *      Max Ammo    2000 units
     *      Ammo Pickup 100 units
     */
    fuelAmount= 1500;
    clipAmount= 100;
    class'ChainsawFire'.default.AmmoClass= class'ChainsawAmmo';
    class'ChainsawFire'.default.AmmoPerFire= 1;
    class'ChainsawAmmo'.default.bAcceptsAmmoPickups= true;
    class'ChainsawAmmo'.default.AmmoPickupAmount=clipAmount;
    class'ChainsawAmmo'.default.MaxAmmo= fuelAmount;
    class'ChainsawAmmo'.default.InitialAmount= fuelAmount;
    class'ChainsawPickup'.default.AmmoCost= 15;
    class'ChainsawPickup'.default.BuyClipSize= clipAmount;
    class'ChainsawPickup'.default.AmmoItemName= "Chainsaw fuel";
    class'Chainsaw'.default.bAmmoHUDAsBar= true;
    class'Chainsaw'.default.bConsumesPhysicalAmmo= true;
    class'Chainsaw'.default.bMeleeWeapon= false;
    class'Chainsaw'.default.MagCapacity= clipAmount;
    class'Chainsaw'.default.bShowChargingBar= true;

    /**
     *  Give chainsaw alt fire its own damage class.  See class 
     *  for change details
     */
    class'ChainsawAltFire'.default.hitDamageClass= class'KFCommBeta.KFCBDamTypeChainsawAlt';

}

function ModifyCommWpn() {
    /**
     *  Replace SCARMK17's default fire class
     *  See the fire class for more details
     */
    class'SCARMK17AssaultRifle'.default.FireModeClass[0]= class'KFCommBeta.KFCBSCARMK17Fire';
}

function ModifyDemoWpn() {
    /**
     *  Increase LAW base damage
     *  Wave 3: Upped to 980 damage
     */
    class'LawProj'.default.Damage= 980;
}

defaultproperties {
	GroupName="KFCommBeta"
	FriendlyName="KF Community Beta"
	Description="Loads the suggestions given by the community.  This version in is 1.2"
}
