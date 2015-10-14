@protocol GHTokenScannerProtocol;
@class GHToken;

@interface GHTokenScanner : NSObject <GHTokenScannerProtocol>

- (id)initWithContentsOfFile:(NSString *)theFileContent;
- (GHToken *)read;
        
@end
