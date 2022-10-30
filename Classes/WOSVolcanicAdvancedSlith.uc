//========================================================================
// WOSVolcanicAdvancedSlith
// WOSVolcanicAdvancedSlith written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSVolcanicAdvancedSlith extends WOSVolcanicSlith;

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{	
	local actor VolcanicUltimaActor;
	
	if (frand() < 0.50)
	{
		VolcanicUltimaActor=spawn(class'VolcanicUltimaChargerActor',self);
		VolcanicUltimaChargerActor(VolcanicUltimaActor).DamageRadius = 1000;
	}
	
	super.Died(Killer,damageType,HitLocation);
}

defaultproperties
{
     MyProjectile=Class'tk_WOSSlith_Beta4c.WOSSlithVolcanicAdvancedProjectile'
     SpecialResistance=0.850000
     aimerror=600
     TakeHitDamageRequired=40
     bAdvanced=True
     ClawDamage=35
     MonsterName="Advanced Volcanic Slith"
     bCanDodge=True
     ScoringValue=7
     bCanStrafe=True
     MeleeRange=55.000000
     GroundSpeed=390.000000
     WaterSpeed=390.000000
     Health=500
}
