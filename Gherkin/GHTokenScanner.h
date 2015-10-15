#import "GHParser.h"

@class GHToken;

@interface GHTokenScanner : NSObject <GHTokenScannerProtocol>

- (id)initWithContentsOfFile:(NSString *)theFilePath;
- (GHToken *)read;
        
@end
