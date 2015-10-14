@class GHLocation;

@interface GHTag : NSObject

@property (nonatomic, readonly) GHLocation  * location;
@property (nonatomic, readonly) NSString    * name;

- (id)initWithLocation:(GHLocation *)theLocation name:(NSString *)theName;

@end