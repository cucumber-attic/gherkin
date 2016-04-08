#import "GHParser+Extensions.h"

#import "GHParser.h"
#import "GHTokenScanner.h"
#import "GHGherkinDocument.h"

@implementation GHParser (Extensions)

- (GHGherkinDocument *)parse:(NSString *)theSourceFile
{
    GHFeature * feature = [self parseWithTokenScanner: [[GHTokenScanner alloc] initWithContentsOfFile: theSourceFile]];
    if(![feature isKindOfClass:[GHFeature class]] || (![feature.name isKindOfClass:[NSString class]] || feature.name.length == 0)){
        return nil;
    }
    return feature;
}

@end
