class ZombieKFCBBloat extends ZombieBloat;

/**
 *  Scales the health this Zed has by number of players
 */
function float NumPlayersHealthModifer() {
    local float AdjustedModifier;
    local int NumEnemies;
    local Controller C;

    AdjustedModifier = 1.0;

    if (KFCBGameType(Level.Game) == none) {
        For( C=Level.ControllerList; C!=None; C=C.NextController )
        {
            if( C.bIsPlayer && C.Pawn!=None && C.Pawn.Health > 0 )
            {
                NumEnemies++;
            }
        }
    } else {
        NumEnemies= KFCBGameType(Level.Game).totalNumPlayersInWave;
    }

    AdjustedModifier += (NumEnemies - 1) * PlayerCountHealthScale;

    return AdjustedModifier;
}

/**
 *  Scales the head health this Zed has by number of players.  
 *  Same implemenatation as NumPlayersHealthModifier()
 */
function float NumPlayersHeadHealthModifer() {
    return NumPlayersHealthModifer();
} 

defaultproperties {
     MenuName="KFCommBeta Bloat"
}
