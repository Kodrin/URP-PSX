// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "PostEffect/Fog"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
    
    CGINCLUDE
        #include "UnityCG.cginc"
        #include "Assets/Shaders/cginc/voronoi.cginc"
    
        sampler2D _MainTex;
        sampler2D _CameraDepthTexture;
        
        float _FogDensity;
        float _FogDistance;
        float4 _FogColor;
        
        float _FogNear;
        float _FogFar;
        float _FogAltScale;
        float _FogThinning;
        
        float _NoiseScale;
        float _NoiseStrength;

        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };
        
        struct v2f
        {
            float4 vertex : SV_POSITION;
            float2 uv : TEXCOORD0;
            float2 screenPosition : TEXCOORD1;
            float4 worldPos : TEXCOORD2;
        };
        
        
        float ComputeDistance(float depth)
        {
            float dist = depth * _ProjectionParams.z;
            dist -= _ProjectionParams.y * _FogDistance;
            return dist;
        }
        
        half ComputeFog(float z, float _Density)
        {
            half fog = 0.0;
            fog = exp2(_Density * z);
            //fog = _Density * z;
            //fog = exp2(-fog * fog);
            return saturate(fog);
        }

        v2f Vert(appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;
            o.worldPos = mul(unity_ObjectToWorld, v.vertex);
            o.screenPosition = ComputeScreenPos(o.vertex);
            return o;
        }

        float4 Frag (v2f i) : SV_Target
        {
            //uvs
            float2 screenPos = i.screenPosition.xy;
            float2 screenParam = _ScreenParams.xy;
            float2 uv = i.uv;
            
            //base texture 
            float4 Color = tex2D(_MainTex, uv) ;            
            
            //lighting 
            float3 worldCam = _WorldSpaceCameraPos;
            float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
            float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.worldPos.xyz));
            //float d = length(viewDirection);
            //float l = saturate((d - _FogNear) / (_FogFar - _FogNear) / clamp(i.worldPos.y / _FogAltScale + 1, 1, _FogThinning));
            
            //background and color 
            float4 ambientColor = float4(0.1,0.1,0.1,0.1);
            float4 background = tex2D(_MainTex, i.uv);
            
            //depth handling
            float Depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);
            float linearDepth = Linear01Depth(Depth);
            //float finalDepth = linearDepth * _FogDistance;
            
            float dist = ComputeDistance(Depth);
            float fog = 1.0 - ComputeFog(dist, _FogDensity);
 
            float screenNoise = cnoise(screenPos * screenParam / _NoiseScale);            
  
            return lerp(Color, _FogColor * ambientColor , saturate(fog + (screenNoise * _NoiseStrength)) );
        }
    ENDCG
    
    SubShader
    {
        Cull Off ZWrite Off ZTest Always
        Tags { "RenderPipeline" = "UniversalPipeline"}
        Pass
        {
            CGPROGRAM
                #pragma vertex Vert
                #pragma fragment Frag
            ENDCG
        }
    }
}
