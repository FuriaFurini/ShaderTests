Shader "ShaderTests/Unlit-ColorCorrection"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_CorrectionTex ("Color Correction Table (RGB)", 2D) = "white" {}
		
		_rOffset ("Red Offset", Range(-1,1)) = 1
		_gOffset ("Green Offset", Range(-1,1)) = 1
		_bOffset ("Blue Offset", Range(-1,1)) = 1	
		
	}
	SubShader
	{
    	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    	LOD 200

        Blend SrcAlpha OneMinusSrcAlpha
        //Blend One One // Additive
		//ZWrite Off
		//ZTest Off
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
				float2 gamma : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			sampler2D _CorrectionTex;
	
			fixed _rOffset;
			fixed _gOffset;
			fixed _bOffset;
			
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.gamma = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 orig = tex2D(_MainTex, i.uv);
				fixed4 col;
				col.rgb = 0;
				//get final color from color correction table:
				col.r = tex2D(_CorrectionTex, float2(orig.r + _rOffset,0.9)).r;
				col.g = tex2D(_CorrectionTex, float2(orig.g + _gOffset,0.6)).g;
				col.b = tex2D(_CorrectionTex, float2(orig.b + _bOffset,0.3)).b;

				col.a = orig.a;				
				return col;
			}
			ENDCG
		}
	}
}
