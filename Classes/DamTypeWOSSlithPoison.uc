class DamTypeWOSSlithPoison extends DamTypePoison
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
     DeathStrings(0)="%o couldn't find an antidote for a Slith's poison."
     DeathStrings(1)="%o was executed by a Slith's lethal injection."
     DeathStrings(2)="%o's bloodstream was rearranged more to a Slith's liking."
     DeathStrings(3)="%o spent too long swimming in a Slith's toxic waste."
     DeathStrings(4)="%o was served a nice, refreshing glass of Slith poison."
     DeathStrings(5)="%o couldn't find anyone to suck a Slith's poison out."
     DeathStrings(6)="%o was caught fighting with his Blood-Poison-Count over .08."
     DeathStrings(7)="A Slith's poison broke %o's heart. Literally."
     DeathStrings(8)="A Slith's poison turned %o into a shrivelled husk."
     DeathStrings(9)="A Slith's poison turned %o's innards into the soup du jour."
     DeathString="%o couldn't find an antidote for a Slith's poison."
     bCauseConvulsions=True
     FlashFog=(X=450.000000,Y=700.000000,Z=230.000000)
     DamageOverlayMaterial=Shader'tk_WOSSlith_Beta4c.Slith.SlimeHit'
     DeathOverlayMaterial=Shader'tk_WOSSlith_Beta4c.Slith.SlimeHit'
     DamageOverlayTime=0.500000
}
