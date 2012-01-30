class KFCBVetDemolitions extends BaseVetDemolitions
    abstract;

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    local Inventory CurInv;

    /**
     *  Change spawn kits for demo
     *  Wave 4:
     *      Give M79 to demo at level 5
     *      Give M79 and 3 extra frags at level 6
     */
    if ( KFPRI.ClientVeteranSkillLevel == 5 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.M79GrenadeLauncher", GetCostScaling(KFPRI, class'M79Pickup'));
    if ( KFPRI.ClientVeteranSkillLevel >= 6) {
        for ( CurInv = P.Inventory; CurInv != none; CurInv = CurInv.Inventory ) {
            if (FragAmmo(CurInv) != none) {
                FragAmmo(CurInv).AmmoAmount+= 3;
            }
        }
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.M79GrenadeLauncher", GetCostScaling(KFPRI, class'M79Pickup'));
    }
}

defaultproperties {
     VeterancyName="KFCommBetaDemolitions"

     LevelEffects(5)="50% extra Explosives damage|50% resistance to Explosives|100% increase in grenade capacity|Can carry 7 Remote Explosives|60% discount on Explosives|70% off Remote Explosives|Spawn with an M79"
     LevelEffects(6)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|74% off Remote Explosives|Spawn with an M79 and 3 extra frags"
}
