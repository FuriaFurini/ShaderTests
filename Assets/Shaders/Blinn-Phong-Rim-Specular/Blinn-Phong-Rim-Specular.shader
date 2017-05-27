Shader "ShaderTestsv/Blinn-Phong-Rim-Specular" {
	Properties {
		_AmbientColor 	("Ambient Color", Color) 				= (1,1,1,1)
		_SpecColor 		("Blinn-Phong Specular Color", Color) 	= (1,1,1,1)
		_PSpecColor		("Phong Specular Color", Color)			= (1,1,1,1)
		_RimColor		("Rim Color", Color) 					= (1,1,1,1)
		_MainTex 		("Albedo (RGB)", 2D) = "white" {}
		//_Glossiness ("Smoothness", Range(0,1)) = 0.5
		//_Metallic ("Metallic", Range(0,1)) = 0.0
		_AmbientPower 	("Ambien Power", Range(0,1)) 	= 1
		_DiffPower		("Diffuse Power", Range(0,1)) 	= 1
		_BPSpecPower	("Specular (Blinn-Phong) Power", Range(0,30)) = 1
		_PSpecPower		("Specular (Phong) Power", Range(0,30)) = 1
		_RimPower		("Rim Power", Range(0,5)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		
		#pragma surface surf CustomBlinnPhong

		// Use shader model 3.0 target, to get nicer looking lighting
		//#pragma target 3.0
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		fixed	_BPSpecPower;
		fixed	_PSpecPower;
		fixed 	_DiffPower;
		fixed	_AmbientPower;
		float4 	_AmbientColor;
		float4	_RimColor;
		fixed	_RimPower;
		float4	_PSpecColor;
		
		fixed4 LightingCustomBlinnPhong(SurfaceOutput input, fixed3 lightDir, half3 viewDir, fixed atten){
			fixed4 o;
			//Lambertarian light model (equally intesity from all views):
			float NDotL = dot(input.Normal, lightDir);
			
			//phong specular light (use reflex vector against view vector):
			fixed3 reflex = normalize((2.0 * NDotL * input.Normal) - lightDir); 
			float pSpec = pow(max(0,dot(reflex, viewDir)), max(1.0,_PSpecPower));
			
			//blinn-phong specular light (use normal + light vector against view vector):
			fixed3 NPlusL = normalize(input.Normal + lightDir);
			float bpSpec = pow(max(0,dot(input.Normal, NPlusL)), max(1.0, _BPSpecPower));
			
			//rim effect:
			fixed border = 1 - abs(dot(viewDir,input.Normal));
			
			//final color:
			o.rgb = 
				//Ambient color
				_AmbientColor.rgb * _AmbientPower +
				//+ Diffuse (Lambert)
				(input.Albedo.rgb * NDotL * _LightColor0 * _DiffPower) +
				//+ Blinn-Phong Specular:
				(bpSpec * _LightColor0 * _SpecColor.rgb * atten) +
				// Phong Specular:
				(pSpec * _LightColor0 * _PSpecColor.rgb * atten) +
				//rim effect:
				(border * _LightColor0 * _RimColor.rgb * _RimPower)
				;
				
			//alpha component:	
			o.a = input.Alpha;
			return o;
		}
		
		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _SpecColor;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
