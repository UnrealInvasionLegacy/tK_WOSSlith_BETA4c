//========================================================================
// WOSSlith
// WOSSlith written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSSlith extends SMPSlith;

#EXEC OBJ LOAD FILE=Resources\WOSSlithTex1.utx PACKAGE=tK_WOSSlith_BETA4c

var class<Projectile>             MyProjectile, MySuperProjectile;
var float                         SpecialResistance, SpecialNegationChance, SuperAttackChance, AttackPitch, PitchVariation;
var() array<class<Inventory> >    ImmuneInventory;
var int                           AimError, TakeHitDamageRequired;
var bool                          bAdvanced, bHuge, bSuperAttack, bToxic, bArctic, bVolcanic, bElectric;
var xEmitter                      AdvancedEffect;
var class<xEmitter>               AdvancedEmitter;
var class<DamageType>             MeleeDamageClass;

//Slith are the same species as all other non-friendly monsters
function bool SameSpeciesAs(Pawn P)
{
    if (P.Controller.IsA('FriendlyMonsterController'))
        return false;
    else
        return (Monster(P) != None);
}


//Slith that spawn do this
simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    SetOverlayMaterial( ShieldHitMat, 1.0, false );
    Spawn(class'PlayerSpawnEffect',,,Location + CollisionHeight * vect(0,0,0.75));
    PlaySound(Sound'WeaponSounds.BWeaponSpawn1',Slot_Pain,1*TransientSoundVolume,,400);

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if (bHuge && bAdvanced)
        {
           AdvancedEffect = Spawn(AdvancedEmitter,self);
           WOSSlithAdvancedAura(AdvancedEffect).Enlarge(1.85);
        }
        else if (bAdvanced)
           AdvancedEffect = Spawn(AdvancedEmitter,self);

        if (AdvancedEffect != None)
        {
            AdvancedEffect.SetBase(self);
        }
    }
}


//Slith do not respond to hits until this damage threshold has been passed
function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
    if ( Damage > TakeHitDamageRequired )
        Super.PlayTakeHit(HitLocation,Damage,DamageType);
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
    local vector HitLocation, HitNormal;
    local actor HitActor;

    // check if still in melee range
    If ( (Controller.target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.4 + Controller.Target.CollisionRadius + CollisionRadius)
        && ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - Controller.Target.Location.Z)
            <= FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight))) )
    {
        HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
        if ( HitActor != None )
            return false;
        Controller.Target.TakeDamage(hitdamage, self,HitLocation, pushdir, MeleeDamageClass);
        return true;
    }
    return false;
}


//Basic projectile firing
function FireProjectile()
{
    local vector FireStart,X,Y,Z;
    local float r;

    r = FRand();

    if ( Controller != None )
    {
        GetAxes(Rotation,X,Y,Z);
        FireStart = GetFireStart(X,Y,Z);
        if ( !SavedFireProperties.bInitialized )
        {
            SavedFireProperties.AmmoClass = MyAmmo.Class;
            SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
            SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
            SavedFireProperties.MaxRange = MyAmmo.MaxRange;
            SavedFireProperties.bTossed = MyAmmo.bTossed;
            SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
            SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
            SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
            SavedFireProperties.bInitialized = true;
        }

        if (bSuperAttack && r < SuperAttackChance)
        {
           Spawn(MySuperProjectile,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,AimError));
           PlaySound(FireSound,SLOT_Interact,,,,(AttackPitch+r/PitchVariation));
        }
        else
        {
        Spawn(MyProjectile,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,AimError));
        PlaySound(FireSound,SLOT_Interact,,,,(AttackPitch+r/PitchVariation));
        }
    }
}

//Adjust damage based on resistances and weaknesses
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector momentum, class<DamageType> damageType)
{
    local float DamageProb;
    local float r;

  r = FRand();

    if(InvalidityMomentumSize>VSize(momentum))
        momentum=vect(0,0,0);

    if(Damage>0)
    {
        if(bReduceDamPlayerNum)
        {
            DamageProb=float(Damage)/(Level.Game.NumPlayers+Level.Game.NumBots);
            if(DamageProb<1 && Frand()<DamageProb)
                Damage=1;
            else
                Damage=DamageProb;

        }
    }

    if(bNoCrushVehicle && class<DamTypeRoadkill>(damageType)!=none && Damage>10)
        Damage=10;

      Super(Monster).TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}


//Do not add inventory items that are in the list of immune inventory types
function bool AddInventory(Inventory NewItem)
{
  local int i;

  for (i=0;i<ImmuneInventory.length;i++)
    {
      if (NewItem.class == ImmuneInventory[i])
        {
         return false;
        }
    }

   return super.AddInventory(NewItem);
}

simulated function Destroyed()
{
    super.Destroyed();
    if (AdvancedEffect != none)
    {
       AdvancedEffect.mRegen = false;
       AdvancedEffect.Destroy();
    }
}

State Dying
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;


    simulated function BeginState()
    {
        Super(Pawn).BeginState();
        if (AdvancedEffect != none)
        {
           AdvancedEffect.mRegen = false;
           AdvancedEffect.Destroy();
        }
        AmbientSound = None;
    }

    function Landed(vector HitNormal)
    {
        SetPhysics(PHYS_None);
        if ( !IsAnimating(0) )
            LandThump();
        Super.Landed(HitNormal);
    }

    simulated function Timer()
    {
        if ( !PlayerCanSeeMe() )
            Destroy();
        else if ( LifeSpan <= DeResTime && bDeRes == false )
            StartDeRes();
        else
            SetTimer(1.0, false);
    }
}

defaultproperties
{
     MyProjectile=Class'tk_WOSSlith_Beta4c.WOSSlithToxicProjectile'
     MySuperProjectile=Class'tk_WOSSlith_Beta4c.WOSSlithToxicProjectile'
     SpecialResistance=0.250000
     SpecialNegationChance=0.500000
     SuperAttackChance=0.060000
     AttackPitch=1.000000
     PitchVariation=8.000000
#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
     ImmuneInventory(0)=Class'MonsterAssaultRPG.PoisonInv'
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
     ImmuneInventory(0)=Class'TURRPG2.Effect_Poison'
#endif
     aimerror=700
     TakeHitDamageRequired=14
     bToxic=True
     AdvancedEmitter=Class'tk_WOSSlith_Beta4c.WOSSlithAdvancedAura'
     meleeDamageClass=Class'tk_WOSSlith_Beta4c.DamTypeWOSSlithMeleeDamage'
     FireSound=SoundGroup'WeaponSounds.BioRifle.BioRifleFire'
     AmmunitionClass=Class'tk_WOSSlith_Beta4c.WOSSlithToxicAmmo'
     ScoringValue=5
     WaterSpeed=370.000000
     Skins(0)=FinalBlend'tk_WOSSlith_Beta4c.Slith.SlithFB1'
     Skins(1)=FinalBlend'tk_WOSSlith_Beta4c.Slith.SlithFB1'
}
