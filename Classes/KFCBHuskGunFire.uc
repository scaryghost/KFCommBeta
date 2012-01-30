class KFCBHuskGunFire extends HuskGunFire;

simulated function bool AllowFire() {
    log("KFCBHuskGunFire - "$!KFCBHuskGun(Weapon).bIsInCoolDown);
	return (Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire 
            && !KFCBHuskGun(Weapon).bIsInCoolDown);
}

