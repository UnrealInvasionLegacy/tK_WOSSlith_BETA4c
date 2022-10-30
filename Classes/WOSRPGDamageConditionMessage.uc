//This message is sent to players who have some damage-causing condition (e.g. poison)
class WOSRPGDamageConditionMessage extends LocalMessage;

var localized string PoisonMessage, FrozenMessage, NullMessage, VulnerableMessage;
var(Message) Color   PoisonColor, FrozenColor, NullColor, VulnerableColor;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if (Switch == 0)
		return Default.PoisonMessage;
	if (Switch == 1)
    return Default.FrozenMessage;
  if (Switch == 2)
    return Default.NullMessage;
  if (Switch == 3)
    return Default.VulnerableMessage;
}

static function color GetColor
    (
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2
    )
{
  if (Switch == 0)
		return Default.PoisonColor;
	if (Switch == 1)
    return Default.FrozenColor;
  if (Switch == 2)
    return Default.NullColor;
  if (Switch == 3)
    return Default.VulnerableColor;
}

defaultproperties
{
     PoisonMessage="You are poisoned!"
     FrozenMessage="You are frozen!"
     NullMessage="You are nulled!"
     VulnerableMessage="You are vulnerable!"
     PoisonColor=(B=128,G=192,R=128,A=255)
     FrozenColor=(B=224,G=200,R=200,A=255)
     NullColor=(B=64,R=32,A=255)
     VulnerableColor=(G=200,R=200,A=255)
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=2
     DrawColor=(B=200,G=200,R=200)
     PosY=0.750000
}
