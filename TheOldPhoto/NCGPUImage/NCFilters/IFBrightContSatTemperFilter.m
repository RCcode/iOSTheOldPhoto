
#import "IFBrightContSatTemperFilter.h"

NSString *const kIFBrightContSatTemperShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;   //原图
 uniform sampler2D inputImageTexture2;  //随便给张图即可
 
 uniform float specIntensity2; //亮度(0,1)
 uniform float specIntensity3; //对比度(0.25,1.75)
 uniform float specIntensity4; //饱和度(-1,1)
 uniform float specIntensity5; //色温(-1,1)
 
 mat3 RGBtoYIQ = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.212, -0.523, 0.311);
 mat3 YIQtoRGB = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.105, 1.702);
 
 void main()
 {
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     vec4 filterResult1 = texel * (1.0 + specIntensity2);
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

     gl_FragColor = filterResult4;
 }
 );


@implementation IFBrightContSatTemperFilter
- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFBrightContSatTemperShaderString]))
    {
        return nil;
    }
    
    return self;
}
@end
