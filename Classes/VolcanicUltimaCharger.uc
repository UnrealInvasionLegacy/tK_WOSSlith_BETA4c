class VolcanicUltimaCharger extends emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter138
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         UniformSize=True
         UseVelocityScale=True
         LowDetailFactor=1.000000
         ColorScale(0)=(Color=(R=64))
         ColorScale(1)=(RelativeTime=0.200000,Color=(R=64))
         ColorScale(2)=(RelativeTime=1.000000,Color=(R=255))
         FadeOutStartTime=1.300000
         FadeInEndTime=0.250000
         MaxParticles=15
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=20.000000,Max=20.000000)
         RevolutionsPerSecondRange=(Z=(Min=0.200000,Max=0.500000))
         RevolutionScale(0)=(RelativeRevolution=(Z=2.000000))
         RevolutionScale(1)=(RelativeTime=0.600000)
         RevolutionScale(2)=(RelativeTime=1.000000,RelativeRevolution=(Z=2.000000))
         SpinsPerSecondRange=(X=(Min=0.200000,Max=0.500000))
         StartSizeRange=(X=(Min=4.000000,Max=20.000000),Y=(Min=4.000000,Max=20.000000),Z=(Min=8.000000,Max=8.000000))
         Texture=Texture'EpicParticles.Flares.HotSpot'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.600000,Max=1.600000)
         StartVelocityRadialRange=(Min=-20.000000,Max=-40.000000)
         VelocityLossRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=1.000000,Max=1.000000))
         AddVelocityMultiplierRange=(X=(Max=0.000000))
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=2.000000,Y=2.000000,Z=2.000000))
         VelocityScale(1)=(RelativeTime=0.600000)
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=-10.000000,Y=-10.000000,Z=-10.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_WOSSlith_Beta4c.VolcanicUltimaCharger.SpriteEmitter138'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter139
         SpinParticles=True
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.250000,Max=0.250000),Z=(Min=0.000000,Max=0.000000))
         MaxParticles=3
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'EpicParticles.Flares.FlickerFlare'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'tk_WOSSlith_Beta4c.VolcanicUltimaCharger.SpriteEmitter139'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=4.500000
}
