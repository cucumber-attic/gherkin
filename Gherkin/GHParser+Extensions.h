#import "GHParser+Extensions.h"

@interface GHParser (Extensions)

- (GHFeature *)parse:(NSString *)theSourceFile;

@end