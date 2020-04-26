Shader "PostEffect/Pixelation"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
    
    CGINCLUDE
        #include "UnityCG.cginc"
    
        sampler2D _MainTex;  
        
        //for Pixelation      
        float _WidthPixelation;
        float _HeightPixelation;
        
        //for color precision
        float _ColorPrecision;
        
        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float2 uv : TEXCOORD0;
            float4 vertex : SV_POSITION;
        };
        
        
        v2f Vert(appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;
            return o;
        }

        float4 Frag (v2f i) : SV_Target
        {
            //pixelation 
            float2 uv = i.uv;
            uv.x = floor(uv.x * _WidthPixelation) / _WidthPixelation;
            uv.y = floor(uv.y * _HeightPixelation) / _HeightPixelation;
            
            float4 Color = tex2D(_MainTex, uv) ;
            //color precision
            Color = floor(Color * _ColorPrecision)/_ColorPrecision;
            return Color;
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
