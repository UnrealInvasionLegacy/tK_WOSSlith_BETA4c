//========================================================================
// WOSVolcanicSlith
// WOSVolcanicSlith written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSVolcanicSlith extends WOSSlith;

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector momentum, class<DamageType> damageType)
{
  if ( instigatedBy != None && instigatedBy.Weapon != none && instigatedBy.Weapon.IsA('RW_Rage'))
  {
     Momentum *= (1 - SpecialResistance);
  }
  
  if ( instigatedBy != None && instigatedBy.HasUDamage() )
  {
     Damage *= (1 - SpecialResistance/2);
  }

  if ( instigatedBy != None && instigatedBy.Weapon != none && instigatedBy.Weapon.IsA('RW_Freeze'))
  {
     Momentum *= (1 + SpecialResistance/4);
  }
  
  Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}

defaultproperties
{
     MyProjectile=Class'tk_WOSSlith_Beta4c.WOSSlithVolcanicProjectile'
     MySuperProjectile=Class'tk_WOSSlith_Beta4c.WOSSlithVolcanicProjectile'
     SpecialResistance=0.750000
     SpecialNegationChance=0.000000
     SuperAttackChance=0.110000
     AttackPitch=1.100000
     bToxic=False
     bVolcanic=True
     AdvancedEmitter=Class'tk_WOSSlith_Beta4c.WOSSlithVolcanicAdvancedFlame'
     ClawDamage=30
     MonsterName="Volcanic Slith"
     AmmunitionClass=Class'tk_WOSSlith_Beta4c.WOSSlithVolcanicAmmo'
     Health=250
     Skins(0)=FinalBlend'tk_WOSSlith_Beta4c.Slith.SlithFB6'
     Skins(1)=FinalBlend'tk_WOSSlith_Beta4c.Slith.SlithFB3'
}
