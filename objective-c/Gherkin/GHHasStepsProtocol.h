@class GHStep;

@protocol GHHasStepsProtocol <NSObject>

@property (nonatomic, readonly) NSArray<GHStep *>   * steps;

@end