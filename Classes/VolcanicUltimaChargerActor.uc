class VolcanicUltimaChargerActor extends Actor;

var emitter ChargeEmitter,ExplosionFX;
var float Damage, DamageRadius;
var class<DamageType> DamageType;
var float MomentumTransfer;
var Controller InstigatorController;
var bool bDischarged;

function DoDamage()
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;

	if (Instigator == None && InstigatorController != None)
		Instigator = InstigatorController.Pawn;

	if(bHurtEntry)
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors(class 'Actor', Victims, DamageRadius, Location)
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if ( Victims != self && Victims != Instigator && Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo')
		     && (Pawn(Victims) == None || TeamGame(Level.Game) == None || TeamGame(Level.Game).FriendlyFireScale > 0
		         || Pawn(Victims).Controller == None || !Pawn(Victims).Controller.SameTeamAs(Controller(Owner))) )
		{
			dir = Victims.Location - Location;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			//set HitDamageType early so AbilityUltima.ScoreKill() can use it
			if (Pawn(Victims) != None)
				Pawn(Victims).HitDamageType = DamageType;
			Victims.SetDelayedDamageInstigatorController(InstigatorController);
			if (Monster(Victims) != None)
			Victims.TakeDamage
			(
				1.0,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * MomentumTransfer * dir),
				DamageType
			);			
			else
			Victims.TakeDamage
			(
				damageScale * Damage,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * MomentumTransfer * dir),
				DamageType
			);
		}
	}
	bHurtEntry = false;
}

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
		ChargeEmitter = spawn(class'VolcanicUltimaCharger');

	if (Role == ROLE_Authority)
		InstigatorController = Controller(Owner);

	SetTimer(3.0,false);
	
	Super.PostBeginPlay();
}

simulated function Destroyed()
{
	if (ChargeEmitter != None)
		ChargeEmitter.Destroy();

	if (ExplosionFX != None)
		ExplosionFX.Destroy();
		
	Super.Destroyed();
}

simulated function Timer()
{
	if (!bDischarged)
	{
		if (Level.NetMode != NM_DedicatedServer)
		{
			if (ChargeEmitter != None)
				ChargeEmitter.Destroy();	
			ExplosionFX = spawn(class'ONSTankHitRockEffect');
		}
			
		if (Role == ROLE_Authority)
			DoDamage();
			
		bDischarged = true;
		SetTimer(3.0,false);
	}
	else
		Destroy();
}

defaultproperties
{
     Damage=450.000000
     DamageRadius=2000.000000
     DamageType=Class'tk_WOSSlith_Beta4c.DamTypeVolcanicUltima'
     MomentumTransfer=200000.000000
     DrawType=DT_None
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=10.000000
     TransientSoundVolume=1.000000
     TransientSoundRadius=5000.000000
}
