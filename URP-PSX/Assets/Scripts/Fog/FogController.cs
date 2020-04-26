using System;
using UnityEngine;
using UnityEngine.Rendering;

namespace PSX
{
    [ExecuteInEditMode]
    public class FogController : MonoBehaviour
    {
        [SerializeField] protected VolumeProfile volumeProfile;
        [SerializeField] protected bool isEnabled = true;

        protected Fog fog;
        
        [Range(0,10)]
        [SerializeField] protected float fogDensity = 1.0f;
        [Range(0,100)]
        [SerializeField] protected float fogDistance = 10.0f;
        [Range(0,100)]
        [SerializeField] protected float fogNear = 1.0f;
        [Range(0,100)]
        [SerializeField] protected float fogFar = 100.0f;
        [Range(0,100)]
        [SerializeField] protected float fogAltScale = 10.0f;
        [Range(0,1000)]
        [SerializeField] protected float fogThinning = 100.0f;
        [Range(0,1000)]
        [SerializeField] protected float noiseScale = 100.0f;
        [Range(0,1)]
        [SerializeField] protected float noiseStrength = 0.05f;
        
        [SerializeField] protected Color fogColor;
        
        protected void Update()
        {
            this.SetParams();
        }

        protected void SetParams()
        {
            if (!this.isEnabled) return; 
            if (this.volumeProfile == null) return;
            if (this.fog == null) volumeProfile.TryGet<Fog>(out this.fog);
            if (this.fog == null) return;
            
            
            this.fog.fogDensity.value = this.fogDensity;
            this.fog.fogDistance.value = this.fogDistance;
            this.fog.fogNear.value = this.fogNear;
            this.fog.fogFar.value = this.fogFar;
            this.fog.fogAltScale.value = this.fogAltScale;
            this.fog.fogThinning.value = this.fogThinning;
            this.fog.noiseScale.value = this.noiseScale;
            this.fog.noiseStrength.value = this.noiseStrength;
            this.fog.fogColor.value = this.fogColor;
            
            
            //ACCESSING PARAMS 
            // this.fog.parameters.value
        }
    }
}