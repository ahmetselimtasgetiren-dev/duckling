Shader "Custom/PondWaterWaves"
{
    Properties
    {
        _Color ("Shallow Color", Color) = (0.2, 0.5, 0.6, 0.7)
        _DepthColor ("Deep Color", Color) = (0.0, 0.2, 0.3, 0.7)
        _Transparency ("Transparency", Range(0,1)) = 0.6
        _Smoothness ("Smoothness", Range(0,1)) = 0.9
        _Metallic ("Metallic", Range(0,1)) = 0.0

        _NormalMap ("Normal Map", 2D) = "bump" {}
        _NormalStrength ("Normal Strength", Range(0,1)) = 0.2
        _WaveSpeed ("Wave Speed", Float) = 0.05
        _WaveScale ("Wave Scale", Float) = 1.0
    }

    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 200
        GrabPass { }

        CGPROGRAM
        #pragma surface surf Standard alpha:fade

        sampler2D _GrabTexture;
        fixed4 _Color;
        fixed4 _DepthColor;
        half _Transparency;
        half _Smoothness;
        half _Metallic;

        sampler2D _NormalMap;
        half _NormalStrength;
        half _WaveSpeed;
        half _WaveScale;

        struct Input
        {
            float2 uv_GrabTexture;
            float2 uv_NormalMap;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed depthFactor = saturate(IN.viewDir.y * 2);
            fixed4 waterCol = lerp(_DepthColor, _Color, depthFactor);

            fixed4 grab = tex2D(_GrabTexture, IN.uv_GrabTexture);

            float2 uvN = IN.uv_NormalMap * _WaveScale;
            uvN.x += _Time.y * _WaveSpeed;
            uvN.y += _Time.y * (_WaveSpeed * 0.5);
            fixed3 normalTex = UnpackNormal(tex2D(_NormalMap, uvN));
            o.Normal = normalTex * _NormalStrength;

            o.Albedo = lerp(grab.rgb, waterCol.rgb, 0.5);
            o.Alpha = _Transparency;
            o.Smoothness = _Smoothness;
            o.Metallic = _Metallic;
        }
        ENDCG
    }
}


