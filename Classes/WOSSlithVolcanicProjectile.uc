class WOSSlithVolcanicProjectile extends Projectile;

var xEmitter Trail, GlowParticles;
var class<xEmitter> TrailClass, AdvancedGlowParticlesClass, ImpactSmokeClass, ExplosionChunksClass, ExplosionClass;
var vector VDir;
var int AdrenDivisor;
var float MaxDrain;
var bool bAdvancedProjectile, bHugeProjectile, bSuperProjectile;

simulated function Destroyed()
{
    if ( Trail != None )
        Trail.mRegen = False;
    if ( GlowParticles != None )
        GlowParticles.mRegen = False;
    Super.Destroyed();
}

simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer)
    {
       Trail = Spawn(TrailClass,self);
       GlowParticles = Spawn (AdvancedGlowParticlesClass,self);
    }
    VDir = vector(Rotation);
    Velocity = speed * VDir;
    if ( Level.bDropDetail )
    {
        bDynamicLight = false;
        LightType = LT_None;
    }
    Super.PostBeginPlay();
}

simulated function Landed( vector HitNormal )
{
    Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector X, RefNormal, RefDir;

    if (Other == Instigator) return;
    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            RefDir = RefNormal;
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        HurtRadius(Damage/3, DamageRadius/2, MyDamageType, MomentumTransfer/3, HitLocation );
        Destroy();
    }
    else if ( !Other.IsA('Projectile') || Other.bProjTarget )
    {
        Explode(HitLocation, Normal(HitLocation-Other.Location));
    }
}

function BlowUp(vector HitLocation)
{
    HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal) 
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
	    PlaySound(ImpactSound,,1.5*TransientSoundVolume,,,1.0);
	    spawn(ImpactSmokeClass,,,HitLocation + HitNormal*16 );
	    spawn(ExplosionChunksClass);
	    spawn(ExplosionClass,,,HitLocation + HitNormal*16 );
	    if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
	        Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	}
    BlowUp(HitLocation);
    Destroy(); 
}


simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local actor Victims;
    local float damageScale, dist;
    local vector dir;
    local float AdrenDrain;
    local float DrainTemp;
    local float r;

    if ( bHurtEntry )
        return;
        
    r = FRand();

    bHurtEntry = true;
    foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
    {
        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') )
        {
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
            if ( Instigator == None || Instigator.Controller == None )
                Victims.SetDelayedDamageInstigatorController( InstigatorController );
            if ( Victims == LastTouched )
                LastTouched = None;
            Victims.TakeDamage
            (
                damageScale * DamageAmount,
                Instigator,
                Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
                (damageScale * Momentum * dir),
                DamageType
            );
            if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

            DrainTemp = FMax(1,((damageScale * DamageAmount) / AdrenDivisor ));
            AdrenDrain = -1 * FMin(MaxDrain,DrainTemp);
            
            if ( Pawn(Victims) != none && Pawn(Victims).Controller != none && !Victims.IsA('Monster'))
            {
              if ( (Pawn(Victims).Controller.Adrenaline > 300) && (Pawn(Victims).Controller.Adrenaline < 500) )
                 AdrenDrain *= 1.5;

              if ( Pawn(Victims).Controller.Adrenaline > 500 )
                 AdrenDrain *= 1.5;
  
              if ( Pawn(Victims).Controller.bGodMode )
                 AdrenDrain *= 1.5;
  
              if ( Pawn(Victims).Controller.Adrenaline > 100+AdrenDrain || Pawn(Victims).Controller.bGodMode )
              {
                 Pawn(Victims).Controller.AwardAdrenaline( AdrenDrain );
              }
            }
        }
    }
    if ( (LastTouched != None) && (LastTouched != self) && (LastTouched.Role == ROLE_Authority) && !LastTouched.IsA('FluidSurfaceInfo') )
    {
        Victims = LastTouched;
        LastTouched = None;
        dir = Victims.Location - HitLocation;
        dist = FMax(1,VSize(dir));
        dir = dir/dist;
        damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
        if ( Instigator == None || Instigator.Controller == None )
            Victims.SetDelayedDamageInstigatorController(InstigatorController);
        Victims.TakeDamage
        (
            damageScale * DamageAmount,
            Instigator,
            Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
            (damageScale * Momentum * dir),
            DamageType
        );
        if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
            Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

        DrainTemp = FMax(1,((damageScale * DamageAmount) / AdrenDivisor ));
        AdrenDrain = -1 * FMin(MaxDrain,DrainTemp);

        if ( Pawn(Victims) != none && Pawn(Victims).Controller != none && !Victims.IsA('Monster'))
        {
          if ( (Pawn(Victims).Controller.Adrenaline > 300) && (Pawn(Victims).Controller.Adrenaline < 500) )
             AdrenDrain *= 1.5;
  
          if ( Pawn(Victims).Controller.Adrenaline > 500 )
             AdrenDrain *= 1.5;
  
          if ( Pawn(Victims).Controller.bGodMode )
             AdrenDrain *= 1.5;
  
          if ( Pawn(Victims).Controller.Adrenaline > 100+AdrenDrain || Pawn(Victims).Controller.bGodMode )
          {
             Pawn(Victims).Controller.AwardAdrenaline( AdrenDrain );
          }
        }
    }

    bHurtEntry = false;
}

defaultproperties
{
     TrailClass=Class'tk_WOSSlith_Beta4c.WOSSlithVolcanicTrailFlames'
     ImpactSmokeClass=Class'XEffects.RocketSmokeRing'
     ExplosionChunksClass=Class'XEffects.ExplosionCrap'
     ExplosionClass=Class'XEffects.RocketExplosion'
     AdrenDivisor=30
     MaxDrain=2.000000
     Speed=1200.000000
     MaxSpeed=1200.000000
     Damage=55.000000
     DamageRadius=240.000000
     MomentumTransfer=40000.000000
     MyDamageType=Class'tk_WOSSlith_Beta4c.DamTypeWOSSlithVolcanic'
     ImpactSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     ExplosionDecal=Class'XEffects.RocketMark'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightSaturation=64
     LightBrightness=255.000000
     LightRadius=5.000000
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.BaseProjectileSounds.BFlakCannonProjectile'
     LifeSpan=10.000000
     Mesh=VertMesh'XWeapons_rc.GoopMesh'
     DrawScale=1.200000
     Skins(0)=TexPanner'LavaSkyX.ground.LavaPanAXX'
     AmbientGlow=96
     SoundVolume=224
     SoundRadius=80.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
