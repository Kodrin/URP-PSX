Shader "PostEffect/Dithering"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
    
    CGINCLUDE
        #include "UnityCG.cginc"
    
        sampler2D _MainTex;  
        float2 _MainTex_TexelSize;

        //for dither     
        uint _PatternIndex; 
        float _DitherThreshold;
        float _DitherStrength;
        float _DitherScale;
        
        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float4 position : SV_POSITION;
            float2 uv : TEXCOORD0;
            float4 screenPosition : TEXCOORD1;
        };
        
        float4x4 GetDitherPattern(uint index)
        {
            float4x4 pattern;
      
            if(index == 0)
            {
                pattern = float4x4
                (
                    0 , 1 , 0 , 1 ,
                    1 , 0 , 1 , 0 ,
                    0 , 1 , 0 , 1 ,
                    1 , 0 , 1 , 0 
                );
            }         
            else if(index == 1)
            {
                pattern = float4x4
                (
                    0.23 , 0.2 , 0.6 , 0.2 ,
                    0.2 , 0.43 , 0.2 , 0.77,
                    0.88 , 0.2 , 0.87 , 0.2 ,
                    0.2 , 0.46 , 0.2 , 0 
                );
            }           
            else if(index == 2)
            {
                pattern = float4x4
                (
                     -4.0, 0.0, -3.0, 1.0,
                     2.0, -2.0, 3.0, -1.0,
                     -3.0, 1.0, -4.0, 0.0,
                     3.0, -1.0, 2.0, -2.0
                );
            }       
            else if(index == 3)
            {
                pattern = float4x4
                (
                    1 , 0 , 0 , 1 ,
                    0 , 1 , 1 , 0 ,
                    0 , 1 , 1 , 0 ,
                    1 , 0 , 0 , 1 
                );
            }          
            else 
            {
                pattern = float4x4
                (
                    1 , 1 , 1 , 1 ,
                    1 , 1 , 1 , 1 ,
                    1 , 1 , 1 , 1 ,
                    1 , 1 , 1 , 1 
                );
            }
            
            return pattern;
        }
        
        float PixelBrightness(float3 col)
        {
            return col.r + col.g + col.b / 3.0; //can use averaging or the dot product to evaluate brightness
            //return dot(col, float3(0.34543, 0.65456, 0.287));
        }
        
        float4 GetTexelSize(float width, float height)
        {
            return float4(1/width, 1/height, width, height);
        }
        
        float Get4x4TexValue(float2 uv, float brightness, float4x4 pattern)
        {        
            uint x = uv.x % 4;
            uint y = uv.y % 4;
            
            if((brightness * _DitherThreshold) < pattern[x][y]) 
                return 0;
            else 
                return 1;
        }      
        
        v2f Vert(appdata v)
        {
            v2f o;
            o.position = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;
            o.screenPosition = ComputeScreenPos(o.position);
            return o;
        }

        float4 Frag (v2f i) : SV_Target
        {
            //base texture 
            float4 Color = tex2D(_MainTex, i.uv);
            
            //dithering  
            float4 texelSize = GetTexelSize(1,1);
            float2 screenPos = i.screenPosition.xy / i.screenPosition.w;
            uint2 ditherCoordinate = screenPos * _ScreenParams.xy * texelSize.xy;

            ditherCoordinate /= _DitherScale;
            
            float brightness = PixelBrightness(Color.rgb);
            float4x4 ditherPattern = GetDitherPattern(_PatternIndex);
            float ditherPixel = Get4x4TexValue(ditherCoordinate.xy, brightness, ditherPattern);
            
            return Color * ditherPixel;        
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
