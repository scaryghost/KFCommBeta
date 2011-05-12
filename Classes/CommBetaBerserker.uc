class CommBetaBerserker extends SRVeterancyTypes
    abstract;

struct damReduction {
    var float bloatDamRed;
    var float genDamRed;
};

var int maxStockLevel;
var array<float> FireSpeedModArray;
var array<damReduction> ReduceDamageArray;
var array<float> MeleeMovementSpeedModArray;
var array<int> PerkProgressArray;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum ) {
    if (CurLevel <= default.maxStockLevel) {
        FinalInt= default.PerkProgressArray[CurLevel];
    } else {
		FinalInt = 5500000+GetDoubleScaling(CurLevel,500000);
    }

    return Min(StatOther.RMeleeDamageStat,FinalInt);
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType) {
    if( class<KFWeaponDamageType>(DmgType) != none && class<KFWeaponDamageType>(DmgType).default.bIsMeleeDamage )
    {
        if ( KFPRI.ClientVeteranSkillLevel == 0 )
            return float(InDamage) * 1.10;
        if( KFPRI.ClientVeteranSkillLevel > default.maxStockLevel )
            return float(InDamage) * (1.7 + (0.05 * KFPRI.ClientVeteranSkillLevel));

        // Up to 100% increase in Melee Damage
        return float(InDamage) * (1.0 + (0.20 * float(Min(KFPRI.ClientVeteranSkillLevel, 5))));
    }
    return InDamage;
}

static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other) {
    if ( KFMeleeGun(Other) != none ) {
        if (KFPRI.ClientVeteranSkillLevel <= default.maxStockLevel) {
            return default.FireSpeedModArray[KFPRI.ClientVeteranSkillLevel];
        } else {
            return 0.95+0.05*float(KFPRI.ClientVeteranSkillLevel);
        }
    }
    return 1.0;
}

static function float GetMeleeMovementSpeedModifier(KFPlayerReplicationInfo KFPRI) {
    return default.MeleeMovementSpeedModArray[min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel)];
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster DamageTaker, int InDamage, class<DamageType> DmgType) {
    if ( DmgType == class'DamTypeVomit' ) {
       return float(InDamage) * default.ReduceDamageArray[min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel)].bloatDamRed;
    }

    return float(InDamage) * default.ReduceDamageArray[min(KFPRI.ClientVeteranSkillLevel,default.maxStockLevel)].genDamRed; // 40% reduced Damage(was 50% in Balance Round 1)
}

static function bool CanBeGrabbed(KFPlayerReplicationInfo KFPRI, KFMonster Other) {
    return !Other.IsA('ZombieClot');
}

// Set number times Zed Time can be extended
static function int ZedTimeExtensions(KFPlayerReplicationInfo KFPRI) {
    return Min(KFPRI.ClientVeteranSkillLevel, 4);
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'ChainsawPickup' || Item == class'KatanaPickup')
        return FMax(0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)),0.1); // Up to 70% discount on Melee Weapons
    return 1.0;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    // If Level 5 or 6, give them Chainsaw
    if ( KFPRI.ClientVeteranSkillLevel >= 5 ) {
        KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Chainsaw", GetCostScaling(KFPRI, class'ChainsawPickup'));
    }

    // If Level 6, give them Body Armor(Removed from Suicidal and HoE in Balance Round 7)
    if ( KFPRI.Level.Game.GameDifficulty < 5.0 && KFPRI.ClientVeteranSkillLevel >= default.maxStockLevel ) {
        P.ShieldStrength = 100;
    }
}

static function string GetCustomLevelInfo( byte Level ) {
    local string S;

    S = Default.CustomLevelInfo;
    ReplaceText(S,"%s",GetPercentStr(0.05 * float(Level)-0.05));
    ReplaceText(S,"%d",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
    ReplaceText(S,"%r",GetPercentStr(0.7 + 0.05*float(Level)));
    return S;
}

defaultproperties {
    PerkIndex=4

    OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Berserker'
    OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Berserker_Gold'
    VeterancyName="CommBetaBerserker"
    Requirements(0)="Deal %x damage with melee weapons"

    maxStockLevel= 6

    FireSpeedModArray(0)= 1.00
    FireSpeedModArray(1)= 1.05
    FireSpeedModArray(2)= 1.10
    FireSpeedModArray(3)= 1.10
    FireSpeedModArray(4)= 1.15
    FireSpeedModArray(5)= 1.20
    FireSpeedModArray(6)= 1.25

    ReduceDamageArray(0)= (bloatDamRed=0.90,genDamRed=1.00)
    ReduceDamageArray(1)= (bloatDamRed=0.75,genDamRed=0.95)
    ReduceDamageArray(2)= (bloatDamRed=0.65,genDamRed=0.90)
    ReduceDamageArray(3)= (bloatDamRed=0.50,genDamRed=0.85)
    ReduceDamageArray(4)= (bloatDamRed=0.35,genDamRed=0.80)
    ReduceDamageArray(5)= (bloatDamRed=0.25,genDamRed=0.70)
    ReduceDamageArray(6)= (bloatDamRed=0.20,genDamRed=0.60)

    MeleeMovementSpeedModArray(0)= 0.05
    MeleeMovementSpeedModArray(1)= 0.10
    MeleeMovementSpeedModArray(2)= 0.15
    MeleeMovementSpeedModArray(3)= 0.20
    MeleeMovementSpeedModArray(4)= 0.20
    MeleeMovementSpeedModArray(5)= 0.20
    MeleeMovementSpeedModArray(6)= 0.30

    PerkProgressArray(0)=5000
    PerkProgressArray(1)=25000
    PerkProgressArray(2)=100000
    PerkProgressArray(3)=500000
    PerkProgressArray(4)=1500000
    PerkProgressArray(5)=3500000
    PerkProgressArray(6)=5500000

    LevelEffects(0)="10% extra melee damage|5% faster melee movement|10% less damage from Bloat Bile|10% discount on Katana/Chainsaw|Can't be grabbed by Clots"
    LevelEffects(1)="20% extra melee damage|5% faster melee attacks|10% faster melee movement|25% less damage from Bloat Bile|5% resistance to all damage|20% discount on Katana/Chainsaw|Can't be grabbed by Clots"
    LevelEffects(2)="40% extra melee damage|10% faster melee attacks|15% faster melee movement|35% less damage from Bloat Bile|10% resistance to all damage|30% discount on Katana/Chainsaw|Can't be grabbed by Clots|Zed-Time can be extended by killing an enemy while in slow motion"
    LevelEffects(3)="60% extra melee damage|10% faster melee attacks|20% faster melee movement|50% less damage from Bloat Bile|15% resistance to all damage|40% discount on Katana/Chainsaw|Can't be grabbed by Clots|Up to 2 Zed-Time Extensions"
    LevelEffects(4)="80% extra melee damage|15% faster melee attacks|20% faster melee movement|65% less damage from Bloat Bile|25% resistance to all damage|50% discount on Katana/Chainsaw|Can't be grabbed by Clots|Up to 3 Zed-Time Extensions"
    LevelEffects(5)="100% extra melee damage|20% faster melee attacks|20% faster melee movement|75% less damage from Bloat Bile|30% resistance to all damage|60% discount on Katana/Chainsaw|Spawn with a Chainsaw|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    LevelEffects(6)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on Katana/Chainsaw|Spawn with a Chainsaw and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    CustomLevelInfo="%r extra melee damage|%s faster melee attacks|20% faster melee movement|80% less damage from Bloat Bile|25% resistance to all damage|%d discount on Katana/Chainsaw|Spawn with a Chainsaw and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
}
