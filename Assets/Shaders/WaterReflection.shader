Shader "Custom/WaterReflection"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite", 2D) = "white" {}
        _Tint ("Tint", Color) = (0.6, 0.7, 0.9, 1)
        _DeepColor ("Deep Color", Color) = (0.08, 0.1, 0.18, 1)
        _WaterLine ("Water Line (set by script)", Float) = 0.25
        _Distort ("Ripple Strength", Float) = 0.006
        _WaveFreq ("Ripple Frequency", Float) = 400
        _WaveSpeed ("Ripple Speed", Float) = 3
        _Fade ("Fade To Deep", Float) = 0.8
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "RenderPipeline"="UniversalPipeline" }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off

        Pass
        {
            Tags { "LightMode"="Universal2D" }
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes { float4 positionOS : POSITION; float2 uv : TEXCOORD0; };
            struct Varyings  { float4 positionCS : SV_POSITION; float4 screenPos : TEXCOORD0; };

            TEXTURE2D(_CameraSortingLayerTexture);
            SAMPLER(sampler_CameraSortingLayerTexture);

            CBUFFER_START(UnityPerMaterial)
                float4 _Tint;
                float4 _DeepColor;
                float _WaterLine;
                float _Distort;
                float _WaveFreq;
                float _WaveSpeed;
                float _Fade;
            CBUFFER_END

            Varyings vert (Attributes v)
            {
                Varyings o;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.screenPos = ComputeScreenPos(o.positionCS);
                return o;
            }

            half4 frag (Varyings i) : SV_Target
            {
                float2 suv = i.screenPos.xy / i.screenPos.w;

                // 0 at the waterline, 1 at the bottom of the screen
                float depth = saturate((_WaterLine - suv.y) / max(_WaterLine, 0.001));

                // horizontal ripple bands that shift over time
                float wave = sin(suv.y * _WaveFreq + _Time.y * _WaveSpeed) * sin(suv.x * 7.0 + _Time.y * 0.7);

                float2 ruv;
                ruv.x = suv.x + wave * _Distort * (0.3 + depth);
                ruv.y = 2.0 * _WaterLine - suv.y; // mirror around the waterline

                half4 col = SAMPLE_TEXTURE2D(_CameraSortingLayerTexture, sampler_CameraSortingLayerTexture, ruv);
                col.rgb *= _Tint.rgb;
                col.rgb = lerp(col.rgb, _DeepColor.rgb, saturate(depth * _Fade));
                col.a = 1;
                return col;
            }
            ENDHLSL
        }
    }
}