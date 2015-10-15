#import "GHLineEndingHelper.h"

@implementation GHLineEndingHelper

+ (NSString *)normalizeLineEndings:(NSString *)theText
{
    return [theText stringByReplacingOccurrencesOfString: @"\r\n" withString: @"\n"];
}

+ (NSString *)normalizeJSonLineEndings:(NSString *)theText
{
    return [theText stringByReplacingOccurrencesOfString: @"\\r\\n" withString: @"\\n"];
}

@end
