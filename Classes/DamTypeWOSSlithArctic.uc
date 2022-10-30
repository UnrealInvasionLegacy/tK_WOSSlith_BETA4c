class DamTypeWOSSlithArctic extends DamageType
      abstract;

var array<string> DeathStrings;

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
    local int r;
    r = Rand(10);

    return Default.DeathStrings[r];
}

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';

    if( VictemHealth <= 0 && FRand() < 0.2 )
        HitEffects[1] = class'HitSmoke';
    else if ( FRand() < 0.8 )
        HitEffects[1] = class'HitSmoke';
}

defaultproperties
{
     DeathStrings(0)="%o was chilled by a Slith's arctic breath."
     DeathStrings(1)="%o got frostbitten by an arctic Slith."
     DeathStrings(2)="%o was turned into a tasty popsicle by a Slith."
     DeathStrings(3)="%o now has a better idea of what an ice cube feels like."
     DeathStrings(4)="%o forgot to wear a sweater to protect against a Slith's arctic breath."
     DeathStrings(5)="%o's heart was frozen by an arctic Slith's chilling breath."
     DeathStrings(6)="A Slith sent fatal shivers up %o's spine."
     DeathStrings(7)="An arctic Slith added %o to its ice statuary."
     DeathStrings(8)="A Slith's ice-cold breath flash-froze the breath in %o's lungs."
     DeathStrings(9)="A Slith's icy exhalation froze the blood in %o's veins."
     DeathString="%o was chilled by a Slith's arctic breath."
     bDelayedDamage=True
     FlashFog=(X=350.000000,Y=350.000000,Z=350.000000)
     DamageOverlayMaterial=Shader'tk_WOSSlith_Beta4c.Slith.FrostHit'
     DeathOverlayMaterial=Shader'tk_WOSSlith_Beta4c.Slith.FrostHit'
     DamageOverlayTime=0.500000
     KDamageImpulse=20000.000000
}
