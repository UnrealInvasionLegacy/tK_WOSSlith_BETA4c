//========================================================================
// WOSVolcanicAdvancedHugeSlith
// WOSToxicAdvancedHugeSlith written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSVolcanicAdvancedHugeSlith extends WOSVolcanicHugeSlith;

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{	
	local actor VolcanicUltimaActor;
	
	VolcanicUltimaActor=spawn(class'VolcanicUltimaChargerActor',self);
	
	super.Died(Killer,damageType,HitLocation);
}

defaultproperties
{
     MyProjectile=Class'tk_WOSSlith_Beta4c.WOSSlithVolcanicAdvancedHugeProjectile'
     SpecialResistance=0.850000
     aimerror=600
     TakeHitDamageRequired=60
     bAdvanced=True
     ClawDamage=70
     MonsterName="Advanced Huge Volcanic Slith"
     bCanDodge=True
     ScoringValue=11
     bCanStrafe=True
     MeleeRange=80.000000
     GroundSpeed=340.000000
     WaterSpeed=360.000000
     Health=1100
}
