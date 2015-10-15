#import "GHParser+Extensions.h"

#import "GHParser.h"
#import "GHTokenScanner.h"
#import "GHFeature.h"

@implementation GHParser (Extensions)

- (GHFeature *)parse:(NSString *)theSourceFile
{
    return [self parseWithTokenScanner: [[GHTokenScanner alloc] initWithContentsOfFile: theSourceFile]];
}

@end