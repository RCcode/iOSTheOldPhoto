

#import "IFBrannanFilter.h"

NSString *const kIFBrannanShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;  //process
// uniform sampler2D inputImageTexture3;  //blowout
// uniform sampler2D inputImageTexture4;  //contrast
// uniform sampler2D inputImageTexture5;  //luma
// uniform sampler2D inputImageTexture6;  //screen
 
 uniform float specIntensity;
 uniform float vignetteFlag;
 
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
     vec3 texel = texel_temp.rgb;
     
     vec2 lookup;
     lookup.y = 0.5;
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture2, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture2, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture2, lookup).b;
     
     texel = saturateMatrix * texel;
     
     vec4 texel_temp2 = vec4(texel, 1.0);
     
     vec4 filterResult = mix(texel_temp, texel_temp2, specIntensity);
     if (vignetteFlag > .0){
         vec3 lumaCoeffs = vec3(.3, .59, .11);
         vec2 vignetteCenter = vec2( .5, .5);
         vec3 vignetteColor = vec3(.0, .0, .0);
         float vignetteStart = .3;
         float vignetteEnd = .70;
         float d = distance(textureCoordinate, vec2(vignetteCenter.x, vignetteCenter.y));
         float percent = smoothstep(vignetteStart, vignetteEnd, d);
         filterResult = vec4(mix(filterResult.rgb, vignetteColor, percent), filterResult.a);
     }
     gl_FragColor = filterResult;
 }
);

@implementation IFBrannanFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFBrannanShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
