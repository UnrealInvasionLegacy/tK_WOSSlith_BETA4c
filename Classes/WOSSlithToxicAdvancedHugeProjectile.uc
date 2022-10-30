class WOSSlithToxicAdvancedHugeProjectile extends WOSSlithToxicHugeProjectile;

simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer)
    {
        Trail = Spawn(class'WOSSlithToxicTrailSmokeHuge',self);
    }

    Super.PostBeginPlay();
}

defaultproperties
{
     AdrenDivisor=25
     MaxDrain=7.000000
     PoisonChance=0.510000
     bAdvancedProjectile=True
     Skins(0)=Shader'tk_WOSSlith_Beta4c.Slith.ToxinShader'
}
