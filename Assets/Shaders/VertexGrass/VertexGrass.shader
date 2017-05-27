Shader "ShaderTests/VertexGrass"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_amp ("Amplitud", float) = 1
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
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _amp;
			
			v2f vert (appdata v)
			{
				v2f o;
				//float4 local = mul(_World2Object, v.vertex);
				v.vertex.x += _SinTime.w * ((v.vertex.y < 0)? 0 : v.vertex.y )* _amp;
				//v.vertex.z += _SinTime.w * local.y * _amp;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				
				return col;
			}
			ENDCG
		}
	}
}
