class WOSSlithToxicProjectile extends BioGlob;

#EXEC AUDIO IMPORT FILE="Sounds\SliImpact.wav" NAME="SliImpact" GROUP="Slith"
#EXEC AUDIO IMPORT FILE="Sounds\GelHit.wav" NAME="GelHit" GROUP="Slith"

var int AdrenDivisor, PoisonRating, PoisonLifeSpan;
var float MaxDrain, PoisonChance, PoisonChanceModifier;
var bool bAdvancedProjectile, bHugeProjectile;


simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        Spawn(class'WOSSlithToxicExplosion');
        Spawn(class'xEffects.GoopSparks');
    }
    if ( Fear != None )
        Fear.Destroy();
    if (Trail != None)
        Trail.mRegen = False;
    Super(Projectile).Destroyed();
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local actor Victims;
    local float damageScale, dist;
    local vector dir;
    local float AdrenDrain;
    local float DrainTemp;
    local float r;
    local WOSSlithPoisonInv Inv;

    if ( bHurtEntry )
        return;

    r = FRand();
    PoisonChanceModifier = GoopLevel / 20;

    if (bAdvancedProjectile)
       PoisonRating += 1;
    if (bHugeProjectile)
       PoisonRating += 1;
    if (r > 0.7500)
       PoisonRating += 1;
    if (GoopLevel > 3)
       PoisonRating += 1;

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

               if ((damageScale * DamageAmount) > (DamageAmount/2) && (r < PoisonChance + PoisonChanceModifier))
               {
#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
                 Inv = WOSSlithPoisonInv(Pawn(Victims).FindInventoryType(class'PoisonInv'));
                 if (Inv == None)
                 {
                    Inv = spawn(class'WOSSlithPoisonInv', Pawn(Victims),,, rot(0,0,0));
                    Inv.Modifier = PoisonRating;
                    Inv.LifeSpan = PoisonLifeSpan;
                    Inv.GiveTo(Pawn(Victims));
                 }
                 else
                 {
                    Inv.Modifier = PoisonRating;
                    Inv.LifeSpan = PoisonLifeSpan;
                 }
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
                 Inv = WOSSlithPoisonInv(class'WOSSlithPoisonInv'.static.Create(Pawn(Victims), InstigatorController, PoisonLifeSpan, PoisonRating));
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
           if ((damageScale * DamageAmount) > (DamageAmount/2) && (r < PoisonChance + PoisonChanceModifier))
           {
#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
             Inv = WOSSlithPoisonInv(Pawn(Victims).FindInventoryType(class'PoisonInv'));
             if (Inv == None)
             {
                Inv = spawn(class'WOSSlithPoisonInv', Pawn(Victims),,, rot(0,0,0));
                Inv.Modifier = PoisonRating;
                Inv.LifeSpan = PoisonLifeSpan;
                Inv.GiveTo(Pawn(Victims));
             }
             else
             {
                Inv.Modifier = PoisonRating;
                Inv.LifeSpan = PoisonLifeSpan;
             }
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
             Inv = WOSSlithPoisonInv(class'WOSSlithPoisonInv'.static.Create(Pawn(Victims), InstigatorController, PoisonLifeSpan, PoisonRating));
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
     AdrenDivisor=30
     PoisonRating=1
     PoisonLifeSpan=4
     MaxDrain=3.000000
     PoisonChance=0.210000
     ExplodeSound=Sound'SliImpact'
     MyDamageType=Class'tk_WOSSlith_Beta4c.DamTypeWOSSlithToxic'
     ImpactSound=Sound'GelHit'
     LightHue=110
     LightSaturation=64
     LightRadius=1.000000
     Skins(0)=Shader'X_cp_terrain1.Wet.cp_swampshader1'
     CollisionRadius=5.000000
     CollisionHeight=5.000000
}
