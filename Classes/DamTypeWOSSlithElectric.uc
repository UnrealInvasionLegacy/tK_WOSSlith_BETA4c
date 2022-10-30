class DamTypeWOSSlithElectric extends DamageType
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
     DeathStrings(0)="%o rode a Slith's lightning."
     DeathStrings(1)="%o got a little too close to a Slith's electrical discharge."
     DeathStrings(2)="%o thought he was grounded against a Slith's electrical discharge. Wrong."
     DeathStrings(3)="Not even 10,000 volts will reanimate %o after absorbing a Slith's lightning bolt."
     DeathStrings(4)="%o was jolted by a Slith's lightning."
     DeathStrings(5)="An electric Slith taught %o the jitterbug."
     DeathStrings(6)="%o was charred to a crisp by a Slith's lightning discharge."
     DeathStrings(7)="An electric Slith zapped %o like a bug."
     DeathStrings(8)="%o did not keep going and going after absorbing a Slith's electrical discharge."
     DeathStrings(9)="A Slith gave %o an electrifying experience."
     DeathString="%o rode a Slith's lightning."
     bAlwaysSevers=True
     bCauseConvulsions=True
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DeathOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DamageOverlayTime=0.500000
}
