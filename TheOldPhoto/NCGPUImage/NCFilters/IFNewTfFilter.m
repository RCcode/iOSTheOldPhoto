
#import "IFNewTfFilter.h"

NSString *const kIFNewTfShaderString = SHADER_STRING
(
 precision lowp float;
 varying highp vec2 textureCoordinate; 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3; 
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
 
 void main()
 {     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);     
     float temp1 = specIntensity2;
     if (temp1 > 0.6){
         temp1 = 0.6;
     }
     vec4 filterResult1;
     if (temp1 == 0.0){
         filterResult1 = texel;
     }else{
         vec4 meng1 = texture2D(inputImageTexture2, textureCoordinate);
         filterResult1 = mix(texel , meng1, temp1) *(1.0 + 1.5*temp1);
     }
     float temp2 = specIntensity3;
     if (temp2 > 0.6){
         temp2 = 0.6;
     }
     vec4 filterResult2;
     if (temp2 == 0.0){
         filterResult2 = filterResult1;
     }else{
         vec4 meng2 = texture2D(inputImageTexture3, textureCoordinate);
         filterResult2 = mix(filterResult1 , meng2, temp2) *(1.0 + 1.5*temp2);
     }
     vec4 filterResult3;
     if (specIntensity4 == 0.0){
         filterResult3 = filterResult2;
     }else{
         filterResult3 = filterResult2 * (1.0 + specIntensity4);
     }
     vec3 filterResult4;
     if (specIntensity5 == 0.0){
         filterResult4 = filterResult3.rgb;
     }else{
         vec3 luminancecoeff = vec3(0.2125, 0.7154, 0.0721);
         float intensityf = dot(filterResult3.rgb, luminancecoeff);
         vec3 intensity = vec3(intensityf, intensityf, intensityf);
         filterResult4 = filterResult3.rgb + specIntensity5 * (filterResult3.rgb - intensity);
     }
     vec4 filterResult5;
     if (specIntensity8 == 0.0 && specIntensity9 == 0.0 && specIntensity10 == 0.0 &&
         specIntensity6 == 0.0 && specIntensity7 == 0.0){
         filterResult5 = vec4(filterResult4, 1.0);
     }else{
         vec3 warmFilter = vec3(specIntensity8, specIntensity9, specIntensity10);
         float temperature = specIntensity6;
         float tint = specIntensity7;         
         vec4 source = vec4(filterResult4, 1.0);        
         vec3 yiq = RGBtoYIQ * source.rgb;
         yiq.b = clamp(yiq.b + tint*0.5226*0.1, -0.5226, 0.5226);
         vec3 rgb = YIQtoRGB * yiq;         
         vec3 processed;
         if(vignetteFlag2 > 0.0){
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
     }
     vec4 filterResult6;
     if (specIntensity11 == 1.0){
         filterResult6 = filterResult5;
     }else{
         filterResult6 = vec4(((filterResult5.rgb - vec3(0.5)) * specIntensity11 + vec3(0.5)), filterResult5.w);
     }
     vec4 filterResult7;
     if (specIntensity12 == 0.0){
         filterResult7 = filterResult6;
     }else{
         filterResult7 = vec4((filterResult6.rgb + vec3(specIntensity12)), filterResult6.w) * (1.0 - specIntensity12);
     }     
     vec4 filterResult = filterResult7;
     if (vignetteFlag > .0){
         vec3 lumaCoeffs = vec3(.3, .59, .11);
         vec2 vignetteCenter = vec2( .5, .5);
         vec3 vignetteColor = vec3(0.1, 0.05, 0.0);
         float vignetteStart = 0.49;       
         float vignetteEnd = 0.86;  
         float d = distance(textureCoordinate, vec2(vignetteCenter.x, vignetteCenter.y));
         float percent = smoothstep(vignetteStart, vignetteEnd, d);
         filterResult = vec4(mix(filterResult.rgb, vignetteColor, percent), filterResult.a);
     }
     
     gl_FragColor = vec4(mix(texel.rgb , filterResult.rgb, specIntensity),1.0);     
 }
 
 );



@implementation IFNewTfFilter
- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFNewTfShaderString]))
    {
        return nil;
    }
    return self;
}

@end
