class KFCBPlayerController extends KFPCServ;

function SetPawnClass(string inClass, string inCharacter) {
    PawnClass = Class'KFCommBeta.KFCBHumanPawn';
    inCharacter = Class'KFGameType'.Static.GetValidCharacter(inCharacter);
    PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(inCharacter);
    PlayerReplicationInfo.SetCharacterName(inCharacter);
}

function ShowBuyMenu(string wlTag,float maxweight){
    StopForceFeedback();
    ClientOpenMenu(string(Class'KFCommBeta.KFCBGUIBuyMenu'),,wlTag,string(maxweight));
}

