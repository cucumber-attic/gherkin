#import "NSString+Trim.h"

@implementation NSString (Trim)

- (NSString *)stringByTrimmingStartWithCharactersInSet:(NSCharacterSet *)theCharacterSet
{
    NSUInteger i = 0;
    NSUInteger length = [self length];
    while (i < length && [theCharacterSet characterIsMember: [self characterAtIndex: i]])
    {
        i++;
    }
    
    return i ? [self substringFromIndex: i] : self;
}

@end
