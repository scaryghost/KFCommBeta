class KFCBMutator extends Mutator;

struct oldNewZombiePair {
    var string oldClass;
    var string newClass;
    var bool bReplace;
};

var() config int minNumPlayers;
var array<oldNewZombiePair> replacementArray;

/**
 *  Variables used to configure fire DOT
 */
var int burnDownEnd;
var int flameThrowerIncr;
var int MAC10Incr;

simulated function PostBeginPlay() {
    local KFGameType KF;
    local int i,k;
    local oldNewZombiePair replacementValue;

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
        for(k=0; k<replacementArray.Length; k++) {
            replacementValue= replacementArray[k];
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
    Destroy();
}

function replaceSpecialSquad(out array<KFGameType.SpecialSquad> squadArray) {
    local int i,j,k;
    local oldNewZombiePair replacementValue;
    for(j=0; j<squadArray.Length; j++) {
        for(i=0;i<squadArray[j].ZedClass.Length; i++) {
            for(k=0; k<replacementArray.Length; k++) {
                replacementValue= replacementArray[k];
                if(replacementValue.bReplace && squadArray[j].ZedClass[i] ~= replacementValue.oldClass) {
                    squadArray[j].ZedClass[i]=  replacementValue.newClass;
                }
            }
        }
    }
}

function ModifySharpWpn() {
    /**
     *  Replace the base arrow with our modded arrow.  See the KFCBCrossbowArrow
     *  class for beta specifics
     */
    class'CrossbowFire'.default.ProjectileClass= class'KFCBCrossbowArrow';
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

    replacementArray(0)=(oldClass="KFChar.ZombieFleshPound",newClass="KFCommBeta.KFCBZombieFleshPound",bReplace=true)
    replacementArray(1)=(oldClass="KFChar.ZombieGorefast",newClass="KFCommBeta.KFCBZombieGorefast",bReplace=true)
    replacementArray(2)=(oldClass="KFChar.ZombieStalker",newClass="KFCommBeta.KFCBZombieStalker",bReplace=true)
    replacementArray(3)=(oldClass="KFChar.ZombieSiren",newClass="KFCommBeta.KFCBZombieSiren",bReplace=true)
    replacementArray(4)=(oldClass="KFChar.ZombieScrake",newClass="KFCommBeta.KFCBZombieScrake",bReplace=true)
    replacementArray(5)=(oldClass="KFChar.ZombieHusk",newClass="KFCommBeta.KFCBZombieHusk",bReplace=true)
    replacementArray(6)=(oldClass="KFChar.ZombieCrawler",newClass="KFCommBeta.KFCBZombieCrawler",bReplace=true)
    replacementArray(7)=(oldClass="KFChar.ZombieBloat",newClass="KFCommBeta.KFCBZombieBloat",bReplace=true)
    replacementArray(8)=(oldClass="KFChar.ZombieClot",newClass="KFCommBeta.KFCBZombieClot",bReplace=true)

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
