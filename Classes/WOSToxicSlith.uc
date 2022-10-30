//========================================================================
// WOSToxicSlith
// WOSToxicSlith written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSToxicSlith extends WOSSlith;

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector momentum, class<DamageType> damageType)
{
  if ( instigatedBy != None && instigatedBy.Weapon != none && instigatedBy.Weapon.IsA('RW_EnhancedPoison'))
  {
     Damage *= (1 - SpecialResistance);
     Momentum *= (1 - SpecialResistance);
  }
  
  if ( instigatedBy != None && instigatedBy.Weapon != none && instigatedBy.Weapon.IsA('RW_EnhancedEnergy'))
  {
     Damage *= (1 + SpecialResistance/5);
     Momentum *= (1 + SpecialResistance/5);
  }
  
  Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}

defaultproperties
{
     SpecialResistance=0.750000
     SpecialNegationChance=0.000000
     SuperAttackChance=0.110000
     AdvancedEmitter=Class'tk_WOSSlith_Beta4c.WOSSlithToxicAdvancedMiasma'
     MonsterName="Toxic Slith"
}
