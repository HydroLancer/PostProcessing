//--------------------------------------------------------------------------------------
// Colour Tint Post-Processing Pixel Shader
//--------------------------------------------------------------------------------------
// Just samples a pixel from the scene texture and multiplies it by a fixed colour to tint the scene

#include "Common.hlsli"


//--------------------------------------------------------------------------------------
// Textures (texture maps)
//--------------------------------------------------------------------------------------

// The scene has been rendered to a texture, these variables allow access to that texture
Texture2D    SceneTexture : register(t0);
SamplerState PointSample  : register(s0); // We don't usually want to filter (bilinear, trilinear etc.) the scene texture when
                                          // post-processing so this sampler will use "point sampling" - no filtering


//--------------------------------------------------------------------------------------
// Shader code
//--------------------------------------------------------------------------------------

// Post-processing shader that tints the scene texture to a given colour
float4 main(PostProcessingInput input) : SV_Target
{
	float3 colour1 = SceneTexture.Sample(PointSample, input.uv).rgb;
	float2 offsetUV;
	
	offsetUV = input.uv + float2(1 / gViewportWidth, 0);
	float3 Right = SceneTexture.Sample(PointSample, offsetUV).rgb;
	offsetUV = input.uv + float2(-1 / gViewportWidth, 0);
	float3 Left = SceneTexture.Sample(PointSample, offsetUV).rgb;
	offsetUV = input.uv + float2(0, -1 /gViewportHeight);
	float3 Down = SceneTexture.Sample(PointSample, offsetUV).rgb;
	offsetUV = input.uv + float2(0, 1 / gViewportHeight);
	float3 Up = SceneTexture.Sample(PointSample, offsetUV).rgb;

	offsetUV = input.uv + float2(1 / gViewportWidth, 1 / gViewportHeight);
	float3 TopRight = SceneTexture.Sample(PointSample, offsetUV).rgb;
	offsetUV = input.uv + float2(-1 / gViewportWidth, 1 / gViewportHeight);
	float3 TopLeft = SceneTexture.Sample(PointSample, offsetUV).rgb;
	offsetUV = input.uv + float2(1 / gViewportWidth, -1 / gViewportHeight);
	float3 BottomRight = SceneTexture.Sample(PointSample, offsetUV).rgb;
	offsetUV = input.uv + float2(-1 / gViewportWidth, -1 / gViewportHeight);
	float3 BottomLeft = SceneTexture.Sample(PointSample, offsetUV).rgb;


	float3 finalColour = (Right + Left + Down + Up + BottomLeft + BottomRight + TopLeft + TopRight + colour1) / 9;

	return float4(finalColour, 1);
}