#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
class WOSSlithPoisonInv extends PoisonInv;
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
class WOSSlithPoisonInv extends Effect_Poison;
#endif

var class<DamageType> MyDamageType;
var class<xEmitter> EffectSmokeClass;

#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
simulated function Timer()
{
    local int PoisonDamage;

    if (Role == ROLE_Authority)
    {
        if (Owner == None)
        {
            Destroy();
            return;
        }

        if (Instigator == None && InstigatorController != None)
            Instigator = InstigatorController.Pawn;

        PoisonDamage = PawnOwner.Health * 0.012000 * Modifier;

    if (PoisonDamage < Modifier + 4)
       PoisonDamage = Modifier + 4;

    if (PoisonDamage > 3*Modifier + 10)
       PoisonDamage = 3*Modifier + 10;

    if (PawnOwner.Controller != None)
        {
           if (((PawnOwner.Health - PoisonDamage) > (100/Modifier) ))
           {
         if (PawnOwner.Controller.bGodMode)
         {
              PawnOwner.Health -= PoisonDamage;
              PawnOwner.Controller.NotifyTakeHit(Instigator, PawnOwner.Location, PoisonDamage, MyDamageType, vect(0,0,0));
         }
         else
         {
            PawnOwner.Health -= PoisonDamage;
            PawnOwner.Controller.NotifyTakeHit(Instigator, PawnOwner.Location, PoisonDamage, MyDamageType, vect(0,0,0));
         }
       }
       else
           PawnOwner.TakeDamage(PoisonDamage, Instigator, PawnOwner.Location, vect(0,0,0), MyDamageType);
    }
    }

    if (Level.NetMode != NM_DedicatedServer && PawnOwner != None)
    {
    PawnOwner.Spawn(EffectSmokeClass,PawnOwner);
        if (PawnOwner.IsLocallyControlled() && PlayerController(PawnOwner.Controller) != None)
            PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'WOSRPGDamageConditionMessage', 0);
    }
}
#endif //ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG

#ifeq __RPG_PACKAGE_NAME TURRPG2
state Activated
{
    simulated function Timer()
    {
        local int PoisonDamage;

        Super(RPGEffect).Timer();

        PoisonDamage = Instigator.Health * 0.012000 * Modifier;

        if (PoisonDamage < Modifier + 4)
            PoisonDamage = Modifier + 4;
        if (PoisonDamage > 3 * Modifier + 10)
            PoisonDamage = 3 * Modifier + 10;

        if(PoisonDamage > 0)
        {
            if(Instigator.Controller != None)
            {
                if ((Instigator.Health - PoisonDamage) > (100 / Modifier))
                {
                    if(PoisonDamage < Instigator.Health)
                    {
                        Instigator.Health -= PoisonDamage;
                        Instigator.Controller.NotifyTakeHit(Instigator, Instigator.Location, PoisonDamage, PoisonDamageType, vect(0,0,0));
                        return;
                    }
                }
            }
            Instigator.TakeDamage(PoisonDamage, EffectCauser.Pawn, Instigator.Location, vect(0,0,0), MyDamageType);
        }
    }
}
#endif //ifeq __RPG_PACKAGE_NAME TURRPG2

defaultproperties
{
#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
     MyDamageType=Class'tk_WOSSlith_Beta4c.DamTypeWOSSlithPoison'
     EffectSmokeClass=Class'tk_WOSSlith_Beta4c.WOSSlithPoisonSmokeCloud'
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
     PoisonDamageType=Class'tk_WOSSlith_Beta4c.DamTypeWOSSlithPoison'
     EffectClass=Class'tk_WOSSlith_Beta4c.WOSSlithPoisonSmokeCloud'
#endif
}
