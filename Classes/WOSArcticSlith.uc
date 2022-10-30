//========================================================================
// WOSArcticSlith
// WOSArcticSlith written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSArcticSlith extends WOSSlith;

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector momentum, class<DamageType> damageType)
{
  if ( instigatedBy != None && instigatedBy.Weapon != none && instigatedBy.Weapon.IsA('RW_Freeze'))
  {
     Momentum *= (1 - SpecialResistance);
  }

  if ( instigatedBy != None && instigatedBy.Weapon != none && instigatedBy.Weapon.IsA('RW_Rage'))
  {
     Momentum *= (1 + SpecialResistance/5);
  }

  Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}

defaultproperties
{
     MyProjectile=Class'tk_WOSSlith_Beta4c.WOSSlithArcticProjectile'
     MySuperProjectile=Class'tk_WOSSlith_Beta4c.WOSSlithArcticProjectile'
     SpecialResistance=0.750000
     SpecialNegationChance=0.000000
     SuperAttackChance=0.110000
     AttackPitch=1.750000
#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
     ImmuneInventory(0)=Class'MonsterAssaultRPG.FreezeInv'
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
     ImmuneInventory(0)=Class'TURRPG2.Effect_Freeze'
#endif
     bToxic=False
     bArctic=True
     AdvancedEmitter=Class'tk_WOSSlith_Beta4c.WOSSlithArcticAdvancedFrost'
     MonsterName="Arctic Slith"
     FireSound=Sound'WeaponSounds.BaseFiringSounds.BTranslocatorFire'
     AmmunitionClass=Class'tk_WOSSlith_Beta4c.WOSSlithArcticAmmo'
     ScoringValue=6
     GroundSpeed=310.000000
     WaterSpeed=320.000000
     Health=200
     Skins(0)=FinalBlend'tk_WOSSlith_Beta4c.Slith.SlithFB2'
     Skins(1)=FinalBlend'tk_WOSSlith_Beta4c.Slith.SlithFB2'
}
