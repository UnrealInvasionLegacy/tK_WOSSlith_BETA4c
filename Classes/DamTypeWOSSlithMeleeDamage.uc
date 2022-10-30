class DamTypeWOSSlithMeleeDamage extends MeleeDamage
      abstract;
      
var array<string> DeathStrings;

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
    local int r;
    r = Rand(10);

    return Default.DeathStrings[r];
}

defaultproperties
{
     DeathStrings(0)="%o was eviscerated by a Slith."
     DeathStrings(1)="%o got clawed to death by a Slith."
     DeathStrings(2)="%o lost a fistfight with a Slith."
     DeathStrings(3)="%o was mauled by a rabid Slith."
     DeathStrings(4)="%o was minced by a Slith's razor-sharp claws."
     DeathString="%o was eviscerated by a Slith."
}
