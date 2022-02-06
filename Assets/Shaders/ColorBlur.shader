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

                v2f vert(appdata v)
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

                float2 getTile(float2 gv, float rnd)
                {
                    if (rnd > 0.75)
                        gv = float2(1, 1) - gv;
                    else if (rnd > 0.5)
                        gv = float2(1 - gv.x, gv.y);
                    else if (rnd > 0.25)
                        gv = 1 - float2(1 - gv.x, gv.y);

                    return gv;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    float2 uv = i.uv * 10;
                    float2 gv = frac(uv);
                    float2 id = floor(uv);
                    
                    float rnd = random(id);
                    float2 tile = getTile(gv, rnd);

                    
                    //float s1 = smoothstep(tile.x - _LineWidth, tile.x, tile.y);
                    //float s2 = smoothstep(tile.x, tile.x + _LineWidth, tile.y);
                    //float c = s1;
                    

                    return fixed4(tile, 0, 1);
                }
                ENDCG
            }
        }
}
