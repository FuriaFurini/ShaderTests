#ifndef SHADERUTILS_FOO
#define SHADERUTILS_FOO

uniform sampler2D _MainTex;
uniform float4 _MainTex_ST;
uniform float4 _Color;
// other variables....

struct vertexInput {
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float4 texcoord : TEXCOORD0;
};

struct vertexOutput {
    float4 pos : SV_POSITION;
    float4 tex : TEXCOORD0;
    float4 posWorld : TEXCOORD1;
    float4 posInObjectCoords : TEXCOORD2;
    float3 normalDir : TEXCOORD3;
};

vertexOutput vert(vertexInput v) {
    vertexOutput o;
    // do staff 
    return o;
}

float4 frag(vertexOutput i) : COLOR
{
    // do staff 
    return float4(...);
}
#endif // SHADERUTILS_FOO