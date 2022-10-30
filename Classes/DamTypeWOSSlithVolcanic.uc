class DamTypeWOSSlithVolcanic extends DamageType
      abstract;

var array<string> DeathStrings;

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
    local int r;
    r = Rand(10);

    return Default.DeathStrings[r];
}

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth )
{
    HitEffects[0] = class'HitSmoke';

    if( VictimHealth <= 0 )
        HitEffects[1] = class'HitFlameBig';
    else if ( FRand() < 0.8 )
        HitEffects[1] = class'HitFlame';
}

defaultproperties
{
     DeathStrings(0)="%o was charred by a Slith's flame breath."
     DeathStrings(1)="%o got burnt to a crisp by a volcanic Slith."
     DeathStrings(2)="%o was reduced to cinders by a Slith's flames."
     DeathStrings(3)="%o was blown away by a Slith's volcanic exhalation."
     DeathStrings(4)="%o was drawn like a moth to a Slith's fireball"
     DeathStrings(5)="%o's brain was boiled like an egg by a Slith's flame breath."
     DeathStrings(6)="A Slith's flame cooked %o to perfection."
     DeathStrings(7)="A volcanic Slith's eruption took %o by surprise."
     DeathStrings(8)="A Slith served %o an extra helping of fiery death."
     DeathStrings(9)="A volcanic Slith roasted %o on an open fire."
     DeathString="%o was charred by a Slith's flame breath."
     bAlwaysSevers=True
     bThrowRagdoll=True
     bFlaming=True
     GibPerterbation=0.150000
     KDamageImpulse=20000.000000
}
