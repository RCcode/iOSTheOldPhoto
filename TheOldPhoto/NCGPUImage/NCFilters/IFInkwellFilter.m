

#import "IFInkwellFilter.h"

NSString *const kIFInkWellShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float specIntensity;
 uniform float vignetteFlag;
 
 void main()
 {
     vec4 texel_temp = texture2D(inputImageTexture, textureCoordinate);
     
     vec3 texel = texel_temp.rgb;
     texel = vec3(dot(vec3(0.3, 0.6, 0.1), texel));
     texel = vec3(texture2D(inputImageTexture2, vec2(texel.r, .16666)).r);
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

@implementation IFInkwellFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFInkWellShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
