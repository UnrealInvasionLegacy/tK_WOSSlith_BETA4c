//========================================================================
// WOSArcticHugeSlith
// WOSArcticHugeSlith written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSArcticHugeSlith extends WOSArcticSlith;

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.9 * CollisionRadius * X + 0.9 * CollisionRadius * Z;
}

defaultproperties
{
     MyProjectile=Class'tk_WOSSlith_Beta4c.WOSSlithArcticHugeProjectile'
     TakeHitDamageRequired=50
     bHuge=True
     ClawDamage=50
     MonsterName="Huge Arctic Slith"
     ScoringValue=8
     MeleeRange=75.000000
     GroundSpeed=265.000000
     WaterSpeed=290.000000
     Health=475
     DrawScale=1.850000
     CollisionRadius=54.000000
     CollisionHeight=80.000000
     Mass=800.000000
     Buoyancy=800.000000
}
