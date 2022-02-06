Shader "Unlit/Brown Move"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _RandomMultiplier("Random Multiplier", Range(1, 100000)) = 1.0
         _OffsetX("Offset X", Range(-1000, 1000)) = 0
        _OffsetY("Offset Y", Range(-1000, 1000)) = 0
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
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
                float _LineWidth;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                    return o;
                }

                float random(float2 p)
                {          
                    float d = dot(p, float2(_OffsetX, _OffsetY));
                    float s = sin(d);

                    return frac(s * _RandomMultiplier);
                }

                float noise(float2 uv)
                {
                    float2 id = floor(uv);
                    float2 f = frac(uv);

                    float a = random(id);
                    float b = random(id + float2(1,0));
                    float c = random(id + float2(0, 1));
                    float d = random(id + float2(1, 1));

                    float2 u = f * f * (3 - 2 * f);

                    float x1 = lerp(a, b, u.x);
                    float x2 = lerp(c, d, u.x);

                    return lerp(x1, x2, u.y);
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    float2 uv = i.uv * 10;

                    float col = noise(uv);


                    return fixed4(col, col, col, 1);
                }
                ENDCG
            }
        }
}
