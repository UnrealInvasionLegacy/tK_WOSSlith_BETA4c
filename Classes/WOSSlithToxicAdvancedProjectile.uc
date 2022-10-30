class WOSSlithToxicAdvancedProjectile extends WOSSlithToxicProjectile;

simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer)
    {
        Trail = Spawn(class'WOSSlithToxicTrailSmoke',self);
    }

    Super.PostBeginPlay();
}

defaultproperties
{
     MaxDrain=5.000000
     PoisonChance=0.410000
     bAdvancedProjectile=True
     Skins(0)=Shader'tk_WOSSlith_Beta4c.Slith.ToxinShader'
}
