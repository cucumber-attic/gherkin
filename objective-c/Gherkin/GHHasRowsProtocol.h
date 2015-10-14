@class GHTableRow;

@protocol GHHasRowsProtocol <NSObject>

@property (nonatomic, readonly) NSArray<GHTableRow *>   * rows;

@end