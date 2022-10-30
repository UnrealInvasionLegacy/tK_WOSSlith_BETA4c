//========================================================================
// WOSElectricHugeSlith
// WOSElectricHugeSlith written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSElectricHugeSlith extends WOSElectricSlith;


function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.9 * CollisionRadius * X + 0.9 * CollisionRadius * Z;
}

defaultproperties
{
     HitEmitterClass=Class'tk_WOSSlith_Beta4c.WOSSlithElectricHugeBoltBeam'
     SecHitEmitterClass=Class'tk_WOSSlith_Beta4c.WOSSlithElectricHugeBoltChildBeam'
     NumArcs=3
     SecTraceDist=600.000000
     DamageMin=40
     DamageMax=50
     TakeHitDamageRequired=50
     bHuge=True
     ClawDamage=50
     MonsterName="Huge Electric Slith"
     ScoringValue=8
     MeleeRange=75.000000
     GroundSpeed=340.000000
     WaterSpeed=370.000000
     Health=475
     DrawScale=1.850000
     CollisionRadius=54.000000
     CollisionHeight=80.000000
     Mass=800.000000
     Buoyancy=800.000000
}
