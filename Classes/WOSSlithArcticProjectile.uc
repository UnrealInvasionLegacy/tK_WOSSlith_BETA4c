class WOSSlithArcticProjectile extends Projectile;

var xEmitter Trail, Sparkles, AdvancedSparkles;
var class<xEmitter> TrailClass, SparklesClass, AdvancedSparklesClass, IceSmokeClass, IceSnowflakeClass;
var class<Emitter> ExplosionClass;
var vector VDir;
var int AdrenDivisor, FreezeRating, FreezeLifeSpan;
var float MaxDrain, FreezeChance;
var bool bAdvancedProjectile, bHugeProjectile, bSuperProjectile;
var Sound FreezeSound;

simulated function Destroyed()
{
    if ( Trail != None )
        Trail.mRegen = False;
    if ( Sparkles != None )
        Sparkles.mRegen = False;
    if ( AdvancedSparkles != None )
        AdvancedSparkles.mRegen = False;
    Super.Destroyed();
}

simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer)
    {
       Trail = Spawn(TrailClass,self);
       Sparkles = Spawn (SparklesClass,self);
       AdvancedSparkles = Spawn (AdvancedSparklesClass,self);
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

    if (xPawn(Other) != None && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            RefDir = RefNormal;
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        HurtRadius(Damage/8, DamageRadius/2, MyDamageType, MomentumTransfer/8, HitLocation ); //You still might freeze...
        Destroy();
    }
    else if ( Projectile(Other) == None || Other.bProjTarget )
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
    if ( Level.NetMode != NM_DedicatedServer)
    {
        PlaySound(FreezeSound,,2.5*TransientSoundVolume);
        spawn(IceSmokeClass,,,HitLocation + HitNormal*16 );
        spawn(IceSnowflakeClass);
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
#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
    local FreezeInv Inv;
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
    local Effect_Freeze Inv;
#endif

    if ( bHurtEntry )
        return;

    r = FRand();

    if (bAdvancedProjectile)
       FreezeRating += 1;
    if (bHugeProjectile)
       FreezeLifeSpan += 1;
    if (bSuperProjectile)
       FreezeRating += 1;
    if (r > 0.7500)
       FreezeLifeSpan += 1;

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

            if ( Pawn(Victims) != none && Pawn(Victims).Controller != none && Monster(Victims) == None)
            {
               if ((damageScale * DamageAmount) > (DamageAmount/2) && (r < FreezeChance))
               {
#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
                 Inv = FreezeInv(Pawn(Victims).FindInventoryType(class'FreezeInv'));
                 if (Inv == None)
                 {
                    Inv = spawn(class'WOSSlithFreezeInv', Pawn(Victims),,, rot(0,0,0));
                    Inv.Modifier = FreezeRating;
                    Inv.LifeSpan = FreezeLifeSpan;
                    Inv.GiveTo(Pawn(Victims));
                 }
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
                 Inv = WOSSlithFreezeInv(class'WOSSlithFreezeInv'.static.Create(Pawn(Victims), InstigatorController, FreezeLifeSpan, FreezeRating));
                 Inv.Start();
#endif
               }

              if ( (Pawn(Victims).Controller.Adrenaline > 300) && (Pawn(Victims).Controller.Adrenaline < 500) )
                 AdrenDrain *= 1.25;

              if ( Pawn(Victims).Controller.Adrenaline > 500 )
                 AdrenDrain *= 1.5;

              if ( Pawn(Victims).Controller.bGodMode )
                 AdrenDrain *= 2;

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
           if ((damageScale * DamageAmount) > (DamageAmount/2) && (r < FreezeChance))
           {
#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
             Inv = FreezeInv(Pawn(Victims).FindInventoryType(class'FreezeInv'));
             if (Inv == None)
             {
                Inv = spawn(class'WOSSlithFreezeInv', Pawn(Victims),,, rot(0,0,0));
                Inv.Modifier = FreezeRating;
                Inv.LifeSpan = FreezeLifeSpan;
                Inv.GiveTo(Pawn(Victims));
             }
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
             Inv = WOSSlithFreezeInv(class'WOSSlithFreezeInv'.static.Create(Pawn(Victims), InstigatorController, FreezeLifeSpan, FreezeRating));
             Inv.Start();
#endif
           }

          if ( (Pawn(Victims).Controller.Adrenaline > 300) && (Pawn(Victims).Controller.Adrenaline < 500) )
             AdrenDrain *= 1.25;

          if ( Pawn(Victims).Controller.Adrenaline > 500 )
             AdrenDrain *= 1.5;

          if ( Pawn(Victims).Controller.bGodMode )
             AdrenDrain *= 2;

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
     TrailClass=Class'tk_WOSSlith_Beta4c.WOSSlithArcticTrailSmoke'
     SparklesClass=Class'tk_WOSSlith_Beta4c.WOSSlithArcticTrailSparkles'
     IceSmokeClass=Class'tk_WOSSlith_Beta4c.WOSSlithArcticChillSmoke'
     IceSnowflakeClass=Class'tk_WOSSlith_Beta4c.WOSSlithArcticChillSnowflakes'
     ExplosionClass=Class'tk_WOSSlith_Beta4c.WOSSlithArcticExplosion'
     AdrenDivisor=30
     FreezeRating=1
     FreezeLifeSpan=3
     MaxDrain=2.000000
     FreezeChance=0.410000
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     Speed=800.000000
     MaxSpeed=800.000000
     Damage=30.000000
     DamageRadius=140.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'tk_WOSSlith_Beta4c.DamTypeWOSSlithArctic'
     ExplosionDecal=Class'XEffects.ShockImpactScorch'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=128
     LightSaturation=128
     LightBrightness=255.000000
     LightRadius=5.000000
     DrawType=DT_Sprite
     bHidden=True
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.BaseProjectileSounds.BFlakCannonProjectile'
     LifeSpan=8.000000
     Texture=Texture'Gwotseffects.blueburst2'
     DrawScale=0.060000
     AmbientGlow=96
     Style=STY_Translucent
     SoundVolume=224
     SoundRadius=80.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
