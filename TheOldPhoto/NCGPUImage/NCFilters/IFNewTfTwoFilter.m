
#import "IFNewTfTwoFilter.h"
NSString *const kIFNewTfTwoShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;  //1
 uniform sampler2D inputImageTexture3;  //5
 
 uniform lowp float specIntensity;
 uniform lowp float specIntensity2;
 uniform lowp float specIntensity3;
 uniform lowp float specIntensity4;
 uniform lowp float specIntensity5;
 uniform lowp float specIntensity6;
 
 uniform lowp float specIntensity7;
 uniform lowp float specIntensity8;
 uniform lowp float specIntensity9;
 uniform lowp float specIntensity10;
 uniform lowp float specIntensity11;
 uniform lowp float specIntensity12;
 uniform lowp float specIntensity13;
 uniform lowp float vignetteFlag;
 uniform lowp float vignetteFlag2;
 
 
 mat3 RGBtoYIQ = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.212, -0.523, 0.311);
 mat3 YIQtoRGB = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.105, 1.702); 
 mat3 saturateMatrix = mat3(
                            1.105150,
                            -0.044850,
                            -0.046000,
                            -0.088050,
                            1.061950,
                            -0.089200,
                            -0.017100,
                            -0.017100,
                            1.132900);
 
 vec3 luma = vec3(.3, .59, .11);

 void main()
{
    vec4 texel_temp = texture2D(inputImageTexture, textureCoordinate);
    vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;    
    vec2 lookup;
    lookup.y = 0.5;
    lookup.x = texel.r;    
    texel.r = texture2D(inputImageTexture2, lookup).r;
    lookup.x = texel.g;
    texel.g = texture2D(inputImageTexture2, lookup).g;
    lookup.x = texel.b;
    texel.b = texture2D(inputImageTexture2, lookup).b;    
    texel = saturateMatrix * texel;    
    vec2 tc = (2.0 * textureCoordinate) - 1.0;
    float d = dot(tc, tc);
    vec3 sampled;
    lookup.y = 0.5;
    lookup.x = texel.r;
    sampled.r = texture2D(inputImageTexture3, lookup).r;
    lookup.x = texel.g;
    sampled.g = texture2D(inputImageTexture3, lookup).g;
    lookup.x = texel.b;
    sampled.b = texture2D(inputImageTexture3, lookup).b;
    float value = smoothstep(0.0, 1.0, d);
    texel = mix(sampled, texel, value);    
    lookup.x = texel.r;
    texel.r = texture2D(inputImageTexture3, lookup).r;
    lookup.x = texel.g;
    texel.g = texture2D(inputImageTexture3, lookup).g;
    lookup.x = texel.b;
    texel.b = texture2D(inputImageTexture3, lookup).b;    
    lookup.x = dot(texel, luma);
    texel = mix(texture2D(inputImageTexture3, lookup).rgb, texel, .5);    
    lookup.x = texel.r;
    texel.r = texture2D(inputImageTexture3, lookup).r;
    lookup.x = texel.g;
    texel.g = texture2D(inputImageTexture3, lookup).g;
    lookup.x = texel.b;
    texel.b = texture2D(inputImageTexture3, lookup).b;    
    vec4 texel_temp2 = vec4(texel, 1.0);
    vec4 filterResult2 = mix(texel_temp, texel_temp2, specIntensity2);
    vec4 filterResult3;
    if (specIntensity4 > .0 || specIntensity4 < .0){
        filterResult3 = filterResult2 * (1.0 + specIntensity4);
    }else{
        filterResult3 = filterResult2;
    }
    vec3 filterResult4;
    if (specIntensity5 > .0 || specIntensity5 < .0){
        vec3 luminancecoeff = vec3(0.2125, 0.7154, 0.0721);
        
        //vec3 luminancecoeff = vec3(0.2025, 0.6254, 0.1721);
        float intensityf = dot(filterResult3.rgb, luminancecoeff);
        vec3 intensity = vec3(intensityf, intensityf, intensityf);
        filterResult4 = filterResult3.rgb + specIntensity5 * (filterResult3.rgb - intensity);
    }else{
        filterResult4 = filterResult3.rgb;
    }
    vec4 filterResult5;
    if ((specIntensity8 > .0 || specIntensity8 < .0) || (specIntensity9 > .0 || specIntensity9 < .0) ||
        (specIntensity10 > .0 || specIntensity10 < .0) || (specIntensity6 > .0 || specIntensity6 < .0) ||
        (specIntensity7 > .0 || specIntensity7 < .0)){        
        vec3 warmFilter = vec3(specIntensity8, specIntensity9, specIntensity10);
        float temperature = specIntensity6;
        float tint = specIntensity7;        
        vec4 source = vec4(filterResult4, 1.0);       
        vec3 yiq = RGBtoYIQ * source.rgb;
        yiq.b = clamp(yiq.b + tint*0.5226*0.1, -0.5226, 0.5226);
        vec3 rgb = YIQtoRGB * yiq;        
        vec3 processed;
        if (vignetteFlag2 > .0){
            processed = vec3(
                             (rgb.r >= specIntensity13 ? (2.0 * rgb.r * warmFilter.r) : (1.0 - 2.0 * (1.0 - rgb.r) * (1.0 - warmFilter.r))),
                             (rgb.g >= specIntensity13 ? (2.0 * rgb.g * warmFilter.g) : (1.0 - 2.0 * (1.0 - rgb.g) * (1.0 - warmFilter.g))),
                             (rgb.b >= specIntensity13 ? (2.0 * rgb.b * warmFilter.b) : (1.0 - 2.0 * (1.0 - rgb.b) * (1.0 - warmFilter.b))));
        }else{
            processed = vec3(
                             (rgb.r < specIntensity13 ? (2.0 * rgb.r * warmFilter.r) : (1.0 - 2.0 * (1.0 - rgb.r) * (1.0 - warmFilter.r))),
                             (rgb.g < specIntensity13 ? (2.0 * rgb.g * warmFilter.g) : (1.0 - 2.0 * (1.0 - rgb.g) * (1.0 - warmFilter.g))),
                             (rgb.b < specIntensity13 ? (2.0 * rgb.b * warmFilter.b) : (1.0 - 2.0 * (1.0 - rgb.b) * (1.0 - warmFilter.b))));
        }        
        filterResult5 = vec4(mix(rgb, processed, temperature), source.a);        
    }else{
        filterResult5 = vec4(filterResult4, 1.0);
    }
    vec4 filterResult6;
    if (specIntensity11 > 1.0 || specIntensity11 < 1.0){
        filterResult6 = vec4(((filterResult5.rgb - vec3(0.5)) * specIntensity11 + vec3(0.5)), filterResult5.w);
    }else{
        filterResult6 = filterResult5;
    }
    vec4 filterResult7;
    if (specIntensity12 > .0 || specIntensity12 < .0){
        filterResult7 = vec4((filterResult6.rgb + vec3(specIntensity12)), filterResult6.w) * (0.9 - specIntensity12);
        //filterResult7 = vec4((filterResult6.rgb + vec3(specIntensity12)), filterResult6.w);
    }else{
        filterResult7 = filterResult6;
    }    
    vec4 filterResult = filterResult7;
    if (vignetteFlag > .0){
        vec3 lumaCoeffs = vec3(.3, .59, .11);
        vec2 vignetteCenter = vec2( .5, .5);
        vec3 vignetteColor = vec3(0.1, 0.05, 0.0);
        float vignetteStart = 0.49;       
        float vignetteEnd = 0.86;;    
        float d = distance(textureCoordinate, vec2(vignetteCenter.x, vignetteCenter.y));
        float percent = smoothstep(vignetteStart, vignetteEnd, d);
        filterResult = vec4(mix(filterResult.rgb, vignetteColor, percent), filterResult.a);
    }
    
    gl_FragColor = vec4(mix(texel_temp.rgb , filterResult.rgb, specIntensity),1.0);
    
}
 );

@implementation IFNewTfTwoFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFNewTfTwoShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

