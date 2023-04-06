//--------------------------------------------------------------------------------------
// Vertex Input - currently using a built in vertex index
struct VertexShaderInput {
    uint vertexID : SV_VertexID;
};


struct VertexToFragment {
    float4 position : SV_POSITION;
    float2 uv : UV;
};


static const float3 FULLSCREEN_TRI_VERTS[] = {
    float3(-1.f, -1.f, 0.f),
    float3(-1.f, 3.f, 0.f),
    float3(3.f, -1.f, 0.f)
};


static const float2 FULLSCREEN_TRI_UV[] = {
    float2(0.f, 1.f),
    float2(0.f, -1.f),
    float2(2.f, 1.f)
};


cbuffer UserBuffer : register(b6) {
    float FADE_ALPHA;
    //float3 PADDING;
}


Texture2D<float4> tAlbedo : register(t0); // Texutre used for albedo (color) information
SamplerState sAlbedo : register(s0);      // Sampler used for the Albedo texture

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
VertexToFragment VertexFunction( VertexShaderInput input ) {
    VertexToFragment v2f = (VertexToFragment)0;

    v2f.position = float4(FULLSCREEN_TRI_VERTS[input.vertexID], 1.f);
    v2f.uv = FULLSCREEN_TRI_UV[input.vertexID];

    return v2f;
}


//--------------------------------------------------------------------------------------
// Fragment Shader
// 
// SV_Target0 means the float4 being returned is being drawn to the first bound color target.
float4 FragmentFunction( VertexToFragment input ) : SV_Target0 {
    // Alpha blending by hand
    // FinalColor = fadeColor.a * BLACK.rgb + (1.0f - fadeColor.a) * destColor.rgb;  (first part goes to zero)
    float4 texColor = tAlbedo.Sample( sAlbedo, input.uv );
    float3 fadeColor = (1.f - FADE_ALPHA) * texColor.xyz;

    return float4(fadeColor, 1.f);
}
