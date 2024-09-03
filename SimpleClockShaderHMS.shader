Shader "SimpleClockShader/HMS"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "black" {}
        _TexSizeX("Tex Size X", int) = 32
        _TexSizeY("Tex Size Y", int) = 16
        _UseSizeX("Use Region X", int) = 30
        _UseSizeY("Use Region Y", int) = 14
        _Col("Column Count", int) = 6
        _Row("Row Count", int) = 2
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

            #include "UnityCG.cginc"

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _TexSizeX;
            float _TexSizeY;
            float _UseSizeX;
            float _UseSizeY;
            float _Col;
            float _Row;
            float _Udon_SimpleClockShader_Second;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            #include "../net.narazaka.unity.tiled-number-shader/TiledNumber.cginc"

            fixed4 frag(v2f i) : SV_Target
            {
                uint col = (uint)_Col;
                uint row = (uint)_Row;
                uint allSecond = (uint)_Udon_SimpleClockShader_Second;
                uint second = allSecond % 60;
                uint minute = allSecond / 60 % 60;
                uint hour = allSecond / 3600;
                uint ns[8] = {hour / 10, hour % 10, 10, minute / 10, minute % 10, 10, second / 10, second % 10};
                int position = (int)(i.uv.x * 8);
                float2 tileSize = float2(_UseSizeX / _TexSizeX, _UseSizeY / _TexSizeY);
                float2 tileOffset = float2(0, 1 - _UseSizeY / _TexSizeY);
                float2 uv = TiledNumber_placeTileUV(i.uv, float2(1 / 8.0, 1), float2(position / 8.0, 0), tileSize, tileOffset, ns[position], col, row, false);
                return tex2D(_MainTex, uv);
            }

            ENDCG
        }
    }
}
