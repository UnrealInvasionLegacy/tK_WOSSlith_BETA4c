#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
class WOSSlithFreezeInv extends FreezeInv;
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
class WOSSlithFreezeInv extends Effect_Freeze;
#endif

#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
simulated function Timer()
{
    Local Actor A;
    if(!stopped)
    {

        if (Level.NetMode != NM_DedicatedServer && PawnOwner != None)
        {
            if (PawnOwner.IsLocallyControlled() && PlayerController(PawnOwner.Controller) != None)
                PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'WOSRPGDamageConditionMessage', 1);
        }
        if (Role == ROLE_Authority)
        {
            if(Owner != None)
                A = PawnOwner.spawn(FreezeEffectClass, PawnOwner,, PawnOwner.Location, PawnOwner.Rotation);

            if(!class'RW_Freeze'.static.canTriggerPhysics(PawnOwner))
            {
                stopEffect();
                return;
            }

            if(LifeSpan <= 0.5)
            {
                stopEffect();
                return;
            }

            if (Owner == None)
            {
                Destroy();
                return;
            }

            if (Instigator == None && InstigatorController != None)
                Instigator = InstigatorController.Pawn;
            else if(PawnOwner != None)
                class'RW_Speedy'.static.quickfoot(-8 * Modifier, PawnOwner);
        }
    }
}
#endif //ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG

defaultproperties
{
#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
     FreezeEffectClass=Class'tk_WOSSlith_Beta4c.WOSSlithArcticFreezeSmoke'
     ModifierOverlay=Shader'tk_WOSSlith_Beta4c.Slith.FrostHit'
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
     EffectClass=Class'tk_WOSSlith_Beta4c.WOSSlithArcticFreezeSmoke'
     EffectOverlay=Shader'tk_WOSSlith_Beta4c.Slith.FrostHit'
#endif
}
