#import "GHParser+Extensions.h"

@implementation GHParser

- (GHFeature *)parse:(NSString *)theSourceFile
{
    return [self parse: [GHTokenScanner alloc] initWithContentsOfFile: sourceFile];
}

@end