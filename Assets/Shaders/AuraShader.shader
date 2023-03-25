Shader "Unlit/AuraShader"
{
    Properties
    {
        _ColourA ("Colour A", Color) = (1,1,1,1)
        _ColourB ("Colour B", Color) = (1,1,1,1)
        _ColourStart ("Colour Start", Range(0,1)) = 0
        _ColourStart ("Colour End", Range(0,1)) = 1

    }
        SubShader
    {
        Tags 
        { 
            "RenderType" = "Transparent" // tag informs render pipeline type
            "Queue" = "Transparent" // change render order
         }

        Pass
        {
            Cull Off // disable culling of objects behind - provide transparency through aura shader
            ZWrite Off // disable depth buffer
            Blend One One // additive blend 
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.28318530718 // full rotation of circle in radians

            float4 _ColourA;
            float4 _ColourB;
            float _ColourStart; 
            float _ColourEnd;

            struct MeshData // input data to vertex shader
            {
                float4 vertex : POSITION; // local space vertex position
                float3 normals : NORMAL; // local space normal direction
                float2 uv0 : TEXCOORD0; // first uv channel 0 diffuse/normal map textures
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; //clip space position of each vertex
                float3 normal : TEXCOORD0; 
                float2 uv : TEXCOORD1;

            };

            Interpolators vert( MeshData v ) {  
                // supply data to fragment shader set, clip space of vertex

                Interpolators o;
                o.vertex = UnityObjectToClipPos( v.vertex ); // local space to clip space
                o.normal = UnityObjectToWorldNormal( v.normals );
                o.uv = v.uv0;
                return o;
            };

            float4 frag(Interpolators i) : SV_Target
            {

                float xOffset = sin(i.uv.x * TAU * 5); // create offset curve ripple effect along x axis
                float t = sin((i.uv.y + xOffset - _Time.y * 0.25) * TAU * 1.5) * 0.5 + 0.5; // create the animation effect with offset ripple
                float headRemover = (abs(i.normal.y) < 0.999); // for vertex with normal value 1 or -1, not rendered, else render.
                t *= 1 - i.uv.y; // reverse direction of animation to go upwards on y axis

                float waves = t * headRemover; 
                float4 gradient = lerp(_ColourA, _ColourB, i.uv.y); // create gradient effect from colour A to B along y axis of UV coord
                
                return gradient * waves;

            }
            ENDCG
        }
    }
}
