class KF1017VetSharpshooter extends SRVeterancyTypes
    abstract;

var int maxStockLevel;
var array<int> PerkProgressArray;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum ) {
    if (CurLevel <= default.maxStockLevel) {
        FinalInt= default.PerkProgressArray[CurLevel];
    } else {
        FinalInt = 8500+GetDoubleScaling(CurLevel,2500);
    }

    return Min(StatOther.RHeadshotKillsStat,FinalInt);
}

static function float GetHeadShotDamMulti(KFPlayerReplicationInfo KFPRI, class<DamageType> DmgType) {
    local float ret;

    // Removed extra SS Crossbow headshot damage in Round 1(added back in Round 2) and Removed Single/Dualies Damage for Hell on Earth in Round 6
    // Added Dual Deagles back in for Balance Round 7
    if ( DmgType == class'DamTypeCrossbow' || DmgType == class'DamTypeCrossbowHeadShot' || DmgType == class'DamTypeWinchester' ||
         DmgType == class'DamTypeDeagle' || DmgType == class'DamTypeDualDeagle' || DmgType == class'DamTypeM14EBR' ||
         (DmgType == class'DamTypeDualies' && KFPRI.Level.Game.GameDifficulty < 7.0) ) {
        if ( KFPRI.ClientVeteranSkillLevel <= 3 )  {
            ret = 1.05 + (0.05 * float(KFPRI.ClientVeteranSkillLevel));
        }
        else if ( KFPRI.ClientVeteranSkillLevel == 4 ) {
            ret = 1.30;
        }
        else if ( KFPRI.ClientVeteranSkillLevel == 5 ) {
            ret = 1.50;
        }
        else {
            ret = 1.60; // 60% increase in Crossbow/Winchester/Handcannon damage
        }
    }
    // Reduced extra headshot damage for Single/Dualies in Hell on Earth difficulty(added in Balance Round 6)
    else if ( DmgType == class'DamTypeDualies' && KFPRI.Level.Game.GameDifficulty >= 7.0 ) {
        return (1.0 + (0.08 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)))); // 40% increase in Headshot Damage
    }
    else {
        ret = 1.0; // Fix for oversight in Balance Round 6(which is the reason for the Round 6 second attempt patch)
    }

    if ( KFPRI.ClientVeteranSkillLevel == 0 ) {
        return ret * 1.05;
    }

    return ret * (1.0 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)))); // 50% increase in Headshot Damage
}

//Copied from KFVetSharpshooter for balance patch 1017
static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil) {
    if ( Crossbow(Other.Weapon) != none || Winchester(Other.Weapon) != none ||
         Deagle(Other.Weapon) != none || M14EBRBattleRifle(Other.Weapon) != none ) {
        if ( KFPRI.ClientVeteranSkillLevel == 1) {
            Recoil = 0.75;
        }
        else if ( KFPRI.ClientVeteranSkillLevel == 2 ) {
            Recoil = 0.50;
        }
        else {
            Recoil = 0.25; // 75% recoil reduction with Crossbow/Winchester/Handcannon
        }

        return Recoil;
    }

    Recoil = 1.0;
    Return Recoil;
}

// Modify fire speed
static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other) {
    if ( Winchester(Other) != none ) {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return 1.0;
        return 1.0 + (0.10 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel))); // Up to 60% faster fire rate with Winchester
    }
    return 1.0;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    if ( Crossbow(Other) != none || Winchester(Other) != none ||
         Deagle(Other) != none || M14EBRBattleRifle(Other) != none ) {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return 1.0;
        return 1.0 + (0.10 * float(min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel))); // Up to 60% faster reload with Crossbow/Winchester/Handcannon
    }
    return 1.0;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'DeaglePickup' || Item == class'DualDeaglePickup' || Item == class'M14EBRPickup')
        return FMax(0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)),0.3f); // Up to 70% discount on Handcannon/Dual Handcannons/EBR
    return 1.0;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'CrossbowPickup' )
        return FMax(1.0 - (0.07 * float(KFPRI.ClientVeteranSkillLevel)),0.58f); // Up to 42% discount on Crossbow Bolts(Added in Balance Round 4 at 30%, increased to 42% in Balance Round 7)
    return 1.0;
}

// Give Extra Items as Default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5, give them a  Lever Action Rifle
    if ( KFPRI.ClientVeteranSkillLevel == 5 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Winchester", GetCostScaling(KFPRI, class'DualDeaglePickup'));

    // If Level 6, give them a Crossbow
    if ( KFPRI.ClientVeteranSkillLevel >= 6 )
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Crossbow", GetCostScaling(KFPRI, class'CrossbowPickup'));
}

static function string GetCustomLevelInfo( byte Level ) {
    return default.LevelEffects[6];
}

defaultproperties {
     maxStockLevel=6

     PerkIndex=2
     OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_SharpShooter'
     OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_SharpShooter_Gold'
     VeterancyName="1017Sharpshooter"

     PerkProgressArray(0)=10
     PerkProgressArray(1)=30
     PerkProgressArray(2)=100
     PerkProgressArray(3)=700
     PerkProgressArray(4)=2500
     PerkProgressArray(5)=5500
     PerkProgressArray(6)=8500

     Requirements(0)="Get %x headshot kills with 9mm, Handcannon, Rifle, Crossbow or EBRM14"

     LevelEffects(0)="10% more headshot damage with 9mm, Handcannon, Rifle, Crossbow, and M14|5% extra Headshot damage with all weapons|10% discount on Handcannon/M14"
     LevelEffects(1)="20% more headshot damage with 9mm, Handcannon, Rifle, Crossbow, and M14|25% less recoil with Handcannon, Rifle, Crossbow, and M14|10% faster reload with Handcannon, Rifle, Crossbow, and M14|10% extra headshot damage|20% discount on Handcannon/M14"
     LevelEffects(2)="38% more headshot damage with 9mm, Handcannon, Rifle, Crossbow, and M14|50% less recoil with Handcannon, Rifle, Crossbow, and M14|20% faster reload with Handcannon, Rifle, Crossbow, and M14|20% extra headshot damage|30% discount on Handcannon/M14"
     LevelEffects(3)="56% more headshot damage with 9mm, Handcannon, Rifle, Crossbow, and M14|75% less recoil with Handcannon, Rifle, Crossbow, and M14|30% faster reload with Handcannon, Rifle, Crossbow, and M14|30% extra headshot damage|40% discount on Handcannon/M14"
     LevelEffects(4)="82% more headshot damage with 9mm, Handcannon, Rifle, Crossbow, and M14|75% less recoil with Handcannon, Rifle, Crossbow, and M14|40% faster reload with Handcannon, Rifle, Crossbow, and M14|40% extra headshot damage|50% discount on Handcannon/M14"
     LevelEffects(5)="125% more headshot damage with 9mm, Handcannon, Rifle, Crossbow, and M14|75% less recoil with Handcannon, Rifle, Crossbow, and M14|50% faster reload with Handcannon, Rifle, Crossbow, and M14|50% extra headshot damage|60% discount on Handcannon/M14|Spawn with a Lever Action Rifle"
     LevelEffects(6)="140% more headshot damage with 9mm, Handcannon, Rifle, Crossbow, and M14|75% less recoil with Handcannon, Rifle, Crossbow, and M14|60% faster reload with Handcannon, Rifle, Crossbow, and M14|50% extra headshot damage|70% discount on Handcannon/M14|Spawn with a Crossbow"
//     CustomLevelInfo="%s more headshot damage with 9mm, Handcannon, Rifle, Crossbow, and M14|75% less recoil with Handcannon, Rifle, Crossbow, and M14|%p faster reload with Handcannon, Rifle, Crossbow, and M14|50% extra headshot damage|%d discount on Handcannon/M14|Spawn with a Crossbow"
}
