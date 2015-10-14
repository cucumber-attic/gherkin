#import "GHStep.h"

#import "GHLocation.h"
#import "GHStepArgument.h"

@interface GHStep ()

@property (nonatomic, strong) GHLocation        * location;
@property (nonatomic, strong) NSString          * keyword;
@property (nonatomic, strong) NSString          * text;
@property (nonatomic, strong) GHStepArgument    * stepArgument;

@end

@implementation GHStep

@synthesize location;
@synthesize keyword;
@synthesize text;
@synthesize stepArgument;

- (id)initWithLocation:(GHLocation *)theLocation keyword:(NSString *)theKeyword text:(NSString *)theText stepArgument:(GHStepArgument *)theStepArgument
{
    if (self = [super init])
    {
        location = theLocation;
        keyword = theKeyword;
        text = theText;
        stepArgument = theStepArgument;
    }
    
    return self;
}

@end