class KFCBMutator extends Mutator;

struct replacementPair {
    var string oldClass;
    var string newClass;
    var bool bReplace;
};

var() config int minNumPlayers;
var array<replacementPair> zombieReplaceArray;
var array<replacementPair> pickupReplaceArray;
var array<replacementPair> ammoReplaceArray;

/**
 *  Variables used to configure fire DOT
 */
var int burnDownEnd;
var int flameThrowerIncr;
var int MAC10Incr;

function bool IsBigGunClass(class<Pickup> Gun) {
    return ( Gun == class'ChainsawPickup' );
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    if (KFWeapon(Other) != none) {
        if (IsBigGunClass(KFWeapon(Other).PickupClass)) {
            ReplaceWith(Other,"KFCommBeta.KFCBChainsaw");
            return false;
/*
            Chainsaw(Other).bAmmoHUDAsBar= true;
            Chainsaw(Other).bConsumesPhysicalAmmo= true;
            Chainsaw(Other).bMeleeWeapon= false;
            Chainsaw(Other).MagCapacity= 100;
            Chainsaw(Other).bShowChargingBar= true;

            Chainsaw(Other).FireModeClass[0]=class'KFCommBeta.KFCBChainsawFire';
            Chainsaw(Other).FireModeClass[1]=class'KFCommBeta.KFCBChainsawAltFire';

            Chainsaw(Other).PickupClass=class'KFCommBeta.KFCBChainsawPickup';
            Chainsaw(Other).ItemName="KFCommBeta Chainsaw";

            Chainsaw(Other).ChopSlowRate=0.20;
*/

        }
    }
    if (KFWeaponPickup(Other) != none) {
        if (IsBigGunClass(KFWeaponPickup(Other).class)) {
            ReplaceWith(Other,"KFCommBeta.KFCBChainsawPickup");
            return false;
        }
    }
//    else if (Other.IsA('KFLevelRules'))
//        ModifyTrader(KFLevelRules(Other));
    return true;
}

function PostBeginPlay() {
    local KFGameType KF;
    local int i,k;
    local replacementPair replacementValue;

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

    //Replace all instances of the old specimens with the new ones 
    for( i=0; i<KF.StandardMonsterClasses.Length; i++) {
        for(k=0; k<zombieReplaceArray.Length; k++) {
            replacementValue= zombieReplaceArray[k];
            //Use ~= for case insensitive compare
            if (replacementValue.bReplace && KF.StandardMonsterClasses[i].MClassName ~= replacementValue.oldClass) {
                KF.StandardMonsterClasses[i].MClassName= replacementValue.newClass;
            }
        }
    }

    //Replace the special squad arrays
    replaceSpecialSquad(KF.ShortSpecialSquads);
    replaceSpecialSquad(KF.NormalSpecialSquads);
    replaceSpecialSquad(KF.LongSpecialSquads);
    replaceSpecialSquad(KF.FinalSquads);

    KF.EndGameBossClass= "KFCommBeta.KFCBZombieBoss";
    KF.FallbackMonsterClass= "KFCommBeta.KFCBZombieStalker";

    SetTimer(0.1, false);
}

function Timer() {
//    Destroy();
}

function replaceSpecialSquad(out array<KFGameType.SpecialSquad> squadArray) {
    local int i,j,k;
    local replacementPair replacementValue;
    for(j=0; j<squadArray.Length; j++) {
        for(i=0;i<squadArray[j].ZedClass.Length; i++) {
            for(k=0; k<zombieReplaceArray.Length; k++) {
                replacementValue= zombieReplaceArray[k];
                if(replacementValue.bReplace && squadArray[j].ZedClass[i] ~= replacementValue.oldClass) {
                    squadArray[j].ZedClass[i]=  replacementValue.newClass;
                }
            }
        }
    }
}

function ModifySharpWpn() {
}

function ModifyZerkWpn() {
}

function ModifyCommWpn() {
}

function ModifyDemoWpn() {
}

static function FillPlayInfo(PlayInfo PlayInfo) {
    Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFCBMutator", "minNumPlayers","Min Number of Players", 0, 1, "Text", "0.1;1:6");
}

static event string GetDescriptionText(string property) {
    switch(property) {
        case "minNumPlayers":
            return "Sets the minimum number of players used when scaling specimen hp based on player count";
        default:
            return Super.GetDescriptionText(property);
    }
}

defaultproperties {
    GroupName="KFCommBeta"
    FriendlyName="KF Community Beta"
    Description="Loads the suggestions given by the community.  This version is in 1.4"

    zombieReplaceArray(0)=(oldClass="KFChar.ZombieFleshPound",newClass="KFCommBeta.KFCBZombieFleshPound",bReplace=true)
    zombieReplaceArray(1)=(oldClass="KFChar.ZombieGorefast",newClass="KFCommBeta.KFCBZombieGorefast",bReplace=true)
    zombieReplaceArray(2)=(oldClass="KFChar.ZombieStalker",newClass="KFCommBeta.KFCBZombieStalker",bReplace=true)
    zombieReplaceArray(3)=(oldClass="KFChar.ZombieSiren",newClass="KFCommBeta.KFCBZombieSiren",bReplace=true)
    zombieReplaceArray(4)=(oldClass="KFChar.ZombieScrake",newClass="KFCommBeta.KFCBZombieScrake",bReplace=true)
    zombieReplaceArray(5)=(oldClass="KFChar.ZombieHusk",newClass="KFCommBeta.KFCBZombieHusk",bReplace=true)
    zombieReplaceArray(6)=(oldClass="KFChar.ZombieCrawler",newClass="KFCommBeta.KFCBZombieCrawler",bReplace=true)
    zombieReplaceArray(7)=(oldClass="KFChar.ZombieBloat",newClass="KFCommBeta.KFCBZombieBloat",bReplace=true)
    zombieReplaceArray(8)=(oldClass="KFChar.ZombieClot",newClass="KFCommBeta.KFCBZombieClot",bReplace=true)

    pickupReplaceArray(0)=(oldClass="KFMod.ChainsawPickup",newClass="KFCommBeta.KFCBChainsawPickup",bReplace=true)
    pickupReplaceArray(1)=(oldClass="KFMod.CrossbowPickup",newClass="KFCommBeta.KFCBCrossbowPickup",bReplace=true)
    pickupReplaceArray(2)=(oldClass="KFMod.LAWPickup",newClass="KFCommBeta.KFCBLAWPickup",bReplace=true)
    pickupReplaceArray(3)=(oldClass="KFMod.M14EBRPickup",newClass="KFCommBeta.KFCBM14EBRPickup",bReplace=true)
    pickupReplaceArray(4)=(oldClass="KFMod.SCARMK17Pickup",newClass="KFCommBeta.KFCBSCARMK17Pickup",bReplace=true)
    pickupReplaceArray(5)=(oldClass="KFMod.WinchesterPickup",newClass="KFCommBeta.KFCBWinchesterPickup",bReplace=true)

    ammoReplaceArray(0)=(oldClass="KFMod.ChainsawAmmo",newClass="KFCommBeta.KFCBChainsawAmmo",bReplace=true)

    /**
     *  Alter burn behavior.  Originally is 10 seconds of burn time
     *  Wave 4:
     *      - Reduce burn time to 8 seconds
     *      - Increase spacing between burn damages from [3,5] to [6.5,8.5] 
     *      - For MAC10, from [3,5] to [8,10] because specimens don't take 
     *        extra 1.5x damage from MAC10 DOT, new MAC10 DOT > old
     */
    burnDownEnd= 2
    flameThrowerIncr= 6.5
    MAC10Incr= 8


}
