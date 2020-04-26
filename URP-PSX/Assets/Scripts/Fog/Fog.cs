using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace PSX
{
    public class Fog : VolumeComponent, IPostProcessComponent
    {
        //PARAMETERS HERE!
        [Range(0,10)]
        public FloatParameter fogDensity = new FloatParameter(1.0f);
        [Range(0,100)]
        public FloatParameter fogDistance = new FloatParameter(10.0f);
        public ColorParameter fogColor = new ColorParameter(Color.white);
        
        [Range(0,100)]
        public FloatParameter fogNear = new FloatParameter(1.0f);
        [Range(0,100)]
        public FloatParameter fogFar = new FloatParameter(100.0f);
        [Range(0,100)]
        public FloatParameter fogAltScale = new FloatParameter(10.0f);
        [Range(0,1000)]
        public FloatParameter fogThinning = new FloatParameter(100.0f);
        [Range(0,1000)]
        public FloatParameter noiseScale = new FloatParameter(100.0f);
        [Range(0,1)]
        public FloatParameter noiseStrength = new FloatParameter(0.05f);

        //INTERFACE REQUIREMENT 
        public bool IsActive() => true;
        public bool IsTileCompatible() => false;
    }
}
