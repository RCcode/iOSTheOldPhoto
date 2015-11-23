//precision lowp float;
//
//
//
//varying highp vec2 textureCoordinate;
//
//
//
//uniform sampler2D inputImageTexture;
//
//uniform float specIntensity;
//
//uniform float vignetteFlag;
//
//
//
//void main()
//
//{
//    
//    mat4 colorMatrix = mat4(0.3588, 0.7044, 0.1368, 0.0,
//                            
//                            0.2990, 0.5870, 0.1140, 0.0,
//                            
//                            0.2392, 0.4696, 0.0912 ,0.0,
//                            
//                            0,0,0,1.0);
//    
//    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
//    
//    lowp vec4 outputColor = textureColor * colorMatrix;
//    
//    
//    
//    vec4 filterResult;
//    
//    filterResult = (specIntensity * outputColor) + ((1.0 - specIntensity) * textureColor);
//    
//    
//    
//    
//    
//    if (vignetteFlag > .0){
//        
//        vec3 lumaCoeffs = vec3(.3, .59, .11);
//        
//        vec2 vignetteCenter = vec2( .5, .5);
//        
//        vec3 vignetteColor = vec3(.0, .0, .0);
//        
//        float vignetteStart = .3;
//        
//        float vignetteEnd = .70;
//        
//        float d = distance(textureCoordinate, vec2(vignetteCenter.x, vignetteCenter.y));
//        
//        float percent = smoothstep(vignetteStart, vignetteEnd, d);
//        
//        filterResult = vec4(mix(filterResult.rgb, vignetteColor, percent), filterResult.a);
//        
//    }
//    
//    
//    
//    gl_FragColor = filterResult;
//    
//}

precision lowp float;

varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;   //原图
//uniform sampler2D inputImageTexture2;  //随便给张图即可

uniform float specIntensity2; //亮度(-1,1)
uniform float specIntensity3; //对比度(0.25,1.75)
uniform float specIntensity4; //饱和度(-1,1)
uniform float specIntensity5; //色温(-1,1)
uniform float specIntensity6; //晕影(0.3,1.3)


mat3 RGBtoYIQ = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.212, -0.523, 0.311);
mat3 YIQtoRGB = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.105, 1.702);

void main()
{
    lowp vec4 texel = texture2D(inputImageTexture, textureCoordinate);
    lowp vec4 filterResult1 = texel * (1.0 + specIntensity2);
    vec3 luminancecoeff = vec3(0.2125, 0.7154, 0.0721);
    float intensityf = dot(filterResult1.rgb, luminancecoeff);
    vec3 intensity = vec3(intensityf, intensityf, intensityf);
    vec3 filterResult2 = filterResult1.rgb + specIntensity4 * (filterResult1.rgb - intensity);
    vec3 warmFilter = vec3(0.70, 0.41, 0.10);
    float temperature = specIntensity5;
    float tint = 0.10;
    vec4 source = vec4(filterResult2, 1.0);
    vec3 yiq = RGBtoYIQ * source.rgb;
    yiq.b = clamp(yiq.b + tint*0.5226*0.1, -0.5226, 0.5226);
    vec3 rgb = YIQtoRGB * yiq;
    vec3 processed = vec3(
                          (rgb.r < 0.5 ? (2.0 * rgb.r * warmFilter.r) : (1.0 - 2.0 * (1.0 - rgb.r) * (1.0 - warmFilter.r))),
                          (rgb.g < 0.5 ? (2.0 * rgb.g * warmFilter.g) : (1.0 - 2.0 * (1.0 - rgb.g) * (1.0 - warmFilter.g))),
                          (rgb.b < 0.5 ? (2.0 * rgb.b * warmFilter.b) : (1.0 - 2.0 * (1.0 - rgb.b) * (1.0 - warmFilter.b)))
         
                          );
    vec4 filterResult3 = vec4(mix(rgb, processed, temperature), source.a);
    vec4 filterResult4 = vec4(((filterResult3.rgb - vec3(0.5)) * specIntensity3 + vec3(0.5)), filterResult3.w);
    vec3 lumaCoeffs = vec3(.3, .59, .11);
    vec4 filterResult5;
    if(specIntensity6 < 0.35){
        filterResult5 = filterResult4;
    }else{
      
        vec2 vignetteCenter = vec2( .5, .5);
        vec3 vignetteColor = vec3(.0, .0, .0);
        float vignetteStart = 0.3;
        //.49
        //1.35 - 0.49
        float vignetteEnd = 2.0 - specIntensity6;
        float d = distance(textureCoordinate, vec2(vignetteCenter.x, vignetteCenter.y));
        float percent = smoothstep(vignetteStart, vignetteEnd, d);
        filterResult5 = vec4(mix(filterResult4.rgb, vignetteColor, percent), filterResult4.a);
    }
   
    gl_FragColor = filterResult5;
}


