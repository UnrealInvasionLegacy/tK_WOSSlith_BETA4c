//========================================================================
// WOSElectricSlith
// WOSElectricSlith written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSElectricSlith extends WOSSlith;

var() class<xEmitter> HitEmitterClass;
var() class<xEmitter> SecHitEmitterClass;
var() int NumArcs;
var() float SecDamageMult;
var() float SecTraceDist;
var class<DamageType> DamageType;
var int DamageMin, DamageMax;
var float TraceRange;
var int AdrenDivisor;
var float MaxDrain;


simulated event PostBeginPlay()
{
    super(SMPSlith).PostBeginPlay();
	if ( Level.NetMode != NM_DedicatedServer )
	{
	    if (bHuge)
	    {
	       AdvancedEffect = Spawn(AdvancedEmitter,self);
	       WOSSlithAdvancedAura(AdvancedEffect).Enlarge(2.05);
	    }
	    else
	       AdvancedEffect = Spawn(AdvancedEmitter,self);

	    if (AdvancedEffect != None)
	    {
	        AdvancedEffect.SetBase(self);
	    }
	}
}

function FireProjectile()
{
	local Vector X,Y,Z, End, HitLocation, HitNormal, RefNormal;
  local Actor Other, mainArcHitTarget;
  local int Damage, ReflectNum, arcsRemaining;
  local bool bDoReflect;
  local xEmitter hitEmitter;
  local class<xEmitter> tmpHitEmitClass;
  local float tmpTraceRange;
  local vector arcEnd, mainArcHit;
  local vector Start;
	local rotator Dir;
	local float r, AdrenDrain, DrainTemp;


  GetAxes(Rotation,X,Y,Z);
	Start = GetFireStart(X,Y,Z);
  r = FRand();

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

	Dir = Controller.AdjustAim(SavedFireProperties,Start,AimError);
	PlaySound(FireSound,SLOT_Interact,,,,(AttackPitch+r/PitchVariation));

  arcEnd=GetFireStart(X,Y,Z);
  arcsRemaining = NumArcs;

  tmpHitEmitClass = HitEmitterClass;
  tmpTraceRange = TraceRange;

  ReflectNum = 0;
  while (true)
  {

        bDoReflect = false;
        X = Vector(Dir);
        End = Start + tmpTraceRange * X;
        Other = Trace(HitLocation, HitNormal, End, Start, true);

        if ( Other != None && (Other != Instigator || ReflectNum > 0) )
        {
            if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
            {
                bDoReflect = true;
            }
            else if ( Other != mainArcHitTarget )
            {
                if ( !Other.bWorldGeometry )
                {
                    Damage = (DamageMin + Rand(DamageMax - DamageMin));

                    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
                    {
                       bDoReflect = true;
                       HitNormal = Vect(0,0,0);
                    }
                    else
                    {
						          if ( arcsRemaining < NumArcs )
							           Damage *= SecDamageMult;
                      Other.TakeDamage(Damage, Instigator, HitLocation, X, DamageType);

                      //Adrenaline drain handling
                      DrainTemp = FMax(1,(Damage / AdrenDivisor));
                      AdrenDrain = -1 * FMin(MaxDrain,DrainTemp);

                      if ( Pawn(Other) != none && Pawn(Other).Controller != none )
                      {
                        if ( (Pawn(Other).Controller.Adrenaline > 300) && (Pawn(Other).Controller.Adrenaline < 500) )
                           AdrenDrain *= 1.5;
  
                        if ( Pawn(Other).Controller.Adrenaline > 500 )
                           AdrenDrain *= 2;
  
                        if ( Pawn(Other).Controller.bGodMode )
                           AdrenDrain *= 2;
  
                        if ( Pawn(Other).Controller.Adrenaline > 100+AdrenDrain || Pawn(Other).Controller.bGodMode )
                        {
                           Pawn(Other).Controller.AwardAdrenaline( AdrenDrain );
                        }
                      }

				            }
                }
            else
					      HitLocation = HitLocation + 2.0 * HitNormal;
            }
        }
        else
        {
            HitLocation = End;
            HitNormal = Normal(Start - End);
        }
        hitEmitter = Spawn(tmpHitEmitClass,,, HitLocation, Rotator(HitNormal));
        if ( hitEmitter != None )
			  hitEmitter.mSpawnVecA = arcEnd;

        if( arcsRemaining == NumArcs )
        {
            mainArcHit = HitLocation + (HitNormal * 2.0);
            if ( Other != None && !Other.bWorldGeometry )
                mainArcHitTarget = Other;
        }

        if (bDoReflect && ++ReflectNum < 4)
        {
            //Log("reflecting off"@Other@Start@HitLocation);
            Start = HitLocation;
            Dir = Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
        }
        else if ( arcsRemaining > 0 )
        {
            arcsRemaining--;

            // done parent arc, now move trace point to arc trace hit location and try child arcs from there
            Start = mainArcHit;
            Dir = Rotator(VRand());
            tmpHitEmitClass = SecHitEmitterClass;
            tmpTraceRange = SecTraceDist;
            arcEnd = mainArcHit;
        }
        else
        {
            break;
        }
  }//While
}


function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector momentum, class<DamageType> damageType)
{
  if ( instigatedBy != None && instigatedBy.Weapon != none && instigatedBy.Weapon.IsA('RW_Energy'))
  {
     Momentum *= (1 - SpecialResistance);
  }
  
  if ( instigatedBy != None && instigatedBy.Weapon != none && instigatedBy.Weapon.IsA('RW_NullEntropy'))
  {
     Momentum *= (1 + SpecialResistance/4);
  }

  Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}

defaultproperties
{
     HitEmitterClass=Class'tk_WOSSlith_Beta4c.WOSSlithElectricBoltBeam'
     SecHitEmitterClass=Class'tk_WOSSlith_Beta4c.WOSSlithElectricBoltChildBeam'
     NumArcs=1
     SecDamageMult=0.500000
     SecTraceDist=300.000000
     DamageType=Class'tk_WOSSlith_Beta4c.DamTypeWOSSlithElectric'
     DamageMin=30
     DamageMax=40
     TraceRange=17000.000000
     AdrenDivisor=20
     MaxDrain=4.000000
     MyProjectile=None
     MySuperProjectile=None
     SpecialResistance=0.750000
     SpecialNegationChance=0.000000
     SuperAttackChance=0.110000
     AttackPitch=0.500000
     aimerror=850
     bToxic=False
     bElectric=True
     AdvancedEmitter=Class'tk_WOSSlith_Beta4c.WOSSlithElectricStatic'
     MonsterName="Electric Slith"
     FireSound=Sound'satoreMonsterPackSound.Slith.injur2sl'
     AmmunitionClass=Class'tk_WOSSlith_Beta4c.WOSSlithElectricAmmo'
     ScoringValue=6
     GroundSpeed=400.000000
     WaterSpeed=410.000000
     Health=200
     Skins(0)=FinalBlend'tk_WOSSlith_Beta4c.Slith.SlithFB4'
}
