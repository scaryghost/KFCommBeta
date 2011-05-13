class KFCBGameType extends KFGameType;

var int totalNumPlayersInWave;

function bool outputToChat(string msg) {
    local Controller C;

    for (C = Level.ControllerList; C != None; C = C.NextController) {
        if (PlayerController(C) != None) {
            PlayerController(C).ClientMessage(msg);
        }
    }

    return true;
}

function SetupWave() {
    super.SetupWave();

    //Copied from KFGameType.SetupWave()
    totalNumPlayersInWave= NumPlayers + NumBots;
    outputToChat("Set up the wave!");
}

defaultproperties {
    totalNumPlayersInWave= 0;
    GameName= "KF Community Beta"
    Description= "Testing ideas suggested by TWI forum members"

    //Copied from KFGameType default properties
    EndGameBossClass="KFCommBeta.ZombieKFCBBoss"
    FallbackMonsterClass="KFCommBeta.ZombieKFCBStalker"

    StandardMonsterClasses(0)=(MClassName="KFCommBeta.ZombieKFCBClot",Mid="A")
    StandardMonsterClasses(1)=(MClassName="KFCommBeta.ZombieKFCBCrawler",Mid="B")
    StandardMonsterClasses(2)=(MClassName="KFCommBeta.ZombieKFCBGoreFast",Mid="C")
    StandardMonsterClasses(3)=(MClassName="KFCommBeta.ZombieKFCBStalker",Mid="D")
    StandardMonsterClasses(4)=(MClassName="KFCommBeta.ZombieKFCBScrake",Mid="E")
    StandardMonsterClasses(5)=(MClassName="KFCommBeta.ZombieKFCBFleshpound",Mid="F")
    StandardMonsterClasses(6)=(MClassName="KFCommBeta.ZombieKFCBBloat",Mid="G")
    StandardMonsterClasses(7)=(MClassName="KFCommBeta.ZombieKFCBSiren",Mid="H")
    StandardMonsterClasses(8)=(MClassName="KFCommBeta.ZombieKFCBHusk",Mid="I")

    ShortSpecialSquads(2)=(ZedClass=("KFCommBeta.ZombieKFCBCrawler","KFCommBeta.ZombieKFCBGorefast","KFCommBeta.ZombieKFCBStalker","KFCommBeta.ZombieKFCBScrake"),NumZeds=(2,2,1,1))
    ShortSpecialSquads(3)=(ZedClass=("KFCommBeta.ZombieKFCBBloat","KFCommBeta.ZombieKFCBSiren","KFCommBeta.ZombieKFCBFleshPound"),NumZeds=(1,2,1))
    NormalSpecialSquads(3)=(ZedClass=("KFCommBeta.ZombieKFCBCrawler","KFCommBeta.ZombieKFCBGorefast","KFCommBeta.ZombieKFCBStalker","KFCommBeta.ZombieKFCBScrake"),NumZeds=(2,2,1,1))
    NormalSpecialSquads(4)=(ZedClass=("KFCommBeta.ZombieKFCBFleshPound"),NumZeds=(1))
    NormalSpecialSquads(5)=(ZedClass=("KFCommBeta.ZombieKFCBBloat","KFCommBeta.ZombieKFCBSiren","KFCommBeta.ZombieKFCBFleshPound"),NumZeds=(1,1,1))
    NormalSpecialSquads(6)=(ZedClass=("KFCommBeta.ZombieKFCBBloat","KFCommBeta.ZombieKFCBSiren","KFCommBeta.ZombieKFCBFleshPound"),NumZeds=(1,1,2))
    LongSpecialSquads(4)=(ZedClass=("KFCommBeta.ZombieKFCBCrawler","KFCommBeta.ZombieKFCBGorefast","KFCommBeta.ZombieKFCBStalker","KFCommBeta.ZombieKFCBScrake"),NumZeds=(2,2,1,1))
    LongSpecialSquads(6)=(ZedClass=("KFCommBeta.ZombieKFCBFleshPound"),NumZeds=(1))
    LongSpecialSquads(7)=(ZedClass=("KFCommBeta.ZombieKFCBBloat","KFCommBeta.ZombieKFCBSiren","KFCommBeta.ZombieKFCBFleshPound"),NumZeds=(1,1,1))
    LongSpecialSquads(8)=(ZedClass=("KFCommBeta.ZombieKFCBBloat","KFCommBeta.ZombieKFCBSiren","KFCommBeta.ZombieKFCBScrake","KFCommBeta.ZombieKFCBFleshPound"),NumZeds=(1,2,1,1))
    LongSpecialSquads(9)=(ZedClass=("KFCommBeta.ZombieKFCBBloat","KFCommBeta.ZombieKFCBSiren","KFCommBeta.ZombieKFCBScrake","KFCommBeta.ZombieKFCBFleshPound"),NumZeds=(1,2,1,2))
    FinalSquads(0)=(ZedClass=("KFCommBeta.ZombieKFCBClot"),NumZeds=(4))
    FinalSquads(1)=(ZedClass=("KFCommBeta.ZombieKFCBClot","KFCommBeta.ZombieKFCBCrawler"),NumZeds=(3,1))
    FinalSquads(2)=(ZedClass=("KFCommBeta.ZombieKFCBClot","KFCommBeta.ZombieKFCBStalker","KFCommBeta.ZombieKFCBCrawler"),NumZeds=(3,1,1))
}
