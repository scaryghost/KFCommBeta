class KFCBMutator extends Mutator;

struct replacementPair {
    var class<Object> oldClass;
    var class<Object> newClass;
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

static function int shouldReplace(string objectName, array<replacementPair> replacementArray) {
    local int i, replaceIndex;

    replaceIndex= -1;
    for(i=0; replaceIndex == -1 && i < replacementArray.length; i++) {
        if (objectName ~= String(replacementArray[i].oldClass)) {
            replaceIndex = i;
        }
    }
    
    return replaceIndex;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    local int index;

    if (KFWeaponPickup(Other) != none) {
        index= shouldReplace(String(Other.class), pickupReplaceArray);
        if (index != -1) {
            ReplaceWith(Other,String(pickupReplaceArray[index].newClass));
            return false;
        }
    } else if (KFWeapon(Other) != none) {
        index= shouldReplace(String(KFWeapon(Other).PickupClass.class), pickupReplaceArray);
        if (index != -1) {
            ReplaceWith(Other,String(class<Pickup>(pickupReplaceArray[index].newClass).default.InventoryType));
            return false;
        }
    }
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

    //Replace all instances of the old specimens with the new ones 
    for( i=0; i<KF.StandardMonsterClasses.Length; i++) {
        for(k=0; k<zombieReplaceArray.Length; k++) {
            replacementValue= zombieReplaceArray[k];
            //Use ~= for case insensitive compare
            if (replacementValue.bReplace && KF.StandardMonsterClasses[i].MClassName ~= String(replacementValue.oldClass)) {
                KF.StandardMonsterClasses[i].MClassName= String(replacementValue.newClass);
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

}

function replaceSpecialSquad(out array<KFGameType.SpecialSquad> squadArray) {
    local int i,j,k;
    local replacementPair replacementValue;
    for(j=0; j<squadArray.Length; j++) {
        for(i=0;i<squadArray[j].ZedClass.Length; i++) {
            for(k=0; k<zombieReplaceArray.Length; k++) {
                replacementValue= zombieReplaceArray[k];
                if(replacementValue.bReplace && squadArray[j].ZedClass[i] ~= String(replacementValue.oldClass)) {
                    squadArray[j].ZedClass[i]=  String(replacementValue.newClass);
                }
            }
        }
    }
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

    zombieReplaceArray(0)=(oldClass=class'KFChar.ZombieFleshPound',newClass=class'KFCommBeta.KFCBZombieFleshPound',bReplace=true)
    zombieReplaceArray(1)=(oldClass=class'KFChar.ZombieGorefast',newClass=class'KFCommBeta.KFCBZombieGorefast',bReplace=true)
    zombieReplaceArray(2)=(oldClass=class'KFChar.ZombieStalker',newClass=class'KFCommBeta.KFCBZombieStalker',bReplace=true)
    zombieReplaceArray(3)=(oldClass=class'KFChar.ZombieSiren',newClass=class'KFCommBeta.KFCBZombieSiren',bReplace=true)
    zombieReplaceArray(4)=(oldClass=class'KFChar.ZombieScrake',newClass=class'KFCommBeta.KFCBZombieScrake',bReplace=true)
    zombieReplaceArray(5)=(oldClass=class'KFChar.ZombieHusk',newClass=class'KFCommBeta.KFCBZombieHusk',bReplace=true)
    zombieReplaceArray(6)=(oldClass=class'KFChar.ZombieCrawler',newClass=class'KFCommBeta.KFCBZombieCrawler',bReplace=true)
    zombieReplaceArray(7)=(oldClass=class'KFChar.ZombieBloat',newClass=class'KFCommBeta.KFCBZombieBloat',bReplace=true)
    zombieReplaceArray(8)=(oldClass=class'KFChar.ZombieClot',newClass=class'KFCommBeta.KFCBZombieClot',bReplace=true)

    pickupReplaceArray(0)=(oldClass=class'KFMod.ChainsawPickup',newClass=class'KFCommBeta.KFCBChainsawPickup',bReplace=true)
    pickupReplaceArray(1)=(oldClass=class'KFMod.CrossbowPickup',newClass=class'KFCommBeta.KFCBCrossbowPickup',bReplace=true)
    pickupReplaceArray(2)=(oldClass=class'KFMod.LAWPickup',newClass=class'KFCommBeta.KFCBLAWPickup',bReplace=true)
    pickupReplaceArray(3)=(oldClass=class'KFMod.M14EBRPickup',newClass=class'KFCommBeta.KFCBM14EBRPickup',bReplace=true)
    pickupReplaceArray(4)=(oldClass=class'KFMod.SCARMK17Pickup',newClass=class'KFCommBeta.KFCBSCARMK17Pickup',bReplace=true)
    pickupReplaceArray(5)=(oldClass=class'KFMod.WinchesterPickup',newClass=class'KFCommBeta.KFCBWinchesterPickup',bReplace=true)
    pickupReplaceArray(6)=(oldClass=class'KFMod.SinglePickup',newClass=class'KFCommBeta.KFCBSinglePickup',bReplace=true)
    pickupReplaceArray(7)=(oldClass=class'KFMod.DualiesPickup',newClass=class'KFCommBeta.KFCBDualiesPickup',bReplace=true)
    pickupReplaceArray(8)=(oldClass=class'KFMod.DeaglePickup',newClass=class'KFCommBeta.KFCBDeaglePickup',bReplace=true)
    pickupReplaceArray(9)=(oldClass=class'KFMod.DualDeaglePickup',newClass=class'KFCommBeta.KFCBDualDeaglePickup',bReplace=true)

    ammoReplaceArray(0)=(oldClass=class'KFMod.ChainsawAmmo',newClass=class'KFCommBeta.KFCBChainsawAmmo',bReplace=true)

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
