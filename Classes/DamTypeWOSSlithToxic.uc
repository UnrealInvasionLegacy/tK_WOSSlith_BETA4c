class DamTypeWOSSlithToxic extends DamTypeBioGlob
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
     DeathStrings(0)="%o was slimed by a Slith's septic spew."
     DeathStrings(1)="%o stepped into a Slith's toxic phlegm."
     DeathStrings(2)="%o was dissolved by a Slith's acid slime."
     DeathStrings(3)="%o's pH was fatally altered by a Slith's toxic spew."
     DeathStrings(4)="%o tried a Slith's acidic skin rejuvenation therapy."
     DeathStrings(5)="%o was served a lethal helping of a Slith's poison gelatin."
     DeathStrings(6)="A Slith gave %o a green facial."
     DeathStrings(7)="A Slith discharged its poison glands all over %o. "
     DeathStrings(8)="A Slith slew %o with its deadly miasma."
     DeathStrings(9)="A Slith used %o as a tissue for its toxic mucus."
     DeathString="%o was slimed by a Slith's septic spew."
     bCauseConvulsions=True
     FlashFog=(X=450.000000,Y=700.000000,Z=230.000000)
     DamageOverlayMaterial=Shader'tk_WOSSlith_Beta4c.Slith.SlimeHit'
     DeathOverlayMaterial=Shader'tk_WOSSlith_Beta4c.Slith.SlimeHit'
     DamageOverlayTime=0.500000
}
