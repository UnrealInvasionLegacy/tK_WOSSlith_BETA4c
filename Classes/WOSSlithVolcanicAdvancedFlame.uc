class WOSSlithVolcanicAdvancedFlame extends WOSSlithAdvancedAura;

defaultproperties
{
     mMaxParticles=5
     mDelayRange(1)=0.150000
     mLifeRange(0)=2.500000
     mLifeRange(1)=5.000000
     mPosDev=(X=12.000000,Y=12.000000,Z=12.000000)
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=0.000000
     mPosRelative=True
     mRandOrient=True
     mSpinRange(0)=-20.000000
     mSpinRange(1)=20.000000
     mSizeRange(0)=65.000000
     mSizeRange(1)=85.000000
     mGrowthRate=5.000000
     mColorRange(0)=(A=112)
     mColorRange(1)=(A=112)
     mAttenKa=0.100000
     mAttenFunc=ATF_ExpInOut
     mRandTextures=True
     mNumTileColumns=4
     mNumTileRows=4
     CullDistance=10000.000000
     Physics=PHYS_Trailer
     Skins(0)=Texture'EmitterTextures.MultiFrame.LargeFlames'
     Style=STY_Translucent
}
