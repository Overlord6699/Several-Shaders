Shader "Unlit/Brown Move"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RandomMultiplier ("Random Multiplier", Range(1, 100000)) = 1.0
        _OffsetX("Offset X", Range(-1000, 1000)) = 0
        _OffsetY("Offset Y", Range(-1000, 1000)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _RandomMultiplier;
            float _OffsetX;
            float _OffsetY;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float random(float2 p)
            {
                float d = dot(p, float2(_OffsetX, _OffsetY));
                float s = sin(d);

                return frac(s * _RandomMultiplier);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float rnd = random(i.uv);
                rnd = pow(rnd, 4);

                return fixed4(rnd, rnd, rnd, 1);
            }
            ENDCG
        }
    }
}
