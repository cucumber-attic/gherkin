#import "GHTokenScanner.h"

#import "GHToken.h"
#import "GHLocation.h"
#import "GHGherkinLine.h"
#import "GHParser.h"
#import "GHLineEndingHelper.h"

@implementation GHTokenScanner
{
    NSUInteger          lineNumber;
    NSArray<NSString *> * lines;
}

- (id)initWithContentsOfFile:(NSString *)theFilePath
{
    if (self = [super init])
    {
        lineNumber = 0;
        NSString * fileContent = [GHLineEndingHelper normalizeLineEndings: [NSString stringWithContentsOfFile: theFilePath encoding: NSUTF8StringEncoding error: NULL]];
        lines = [fileContent componentsSeparatedByString: @"\n"];
    }
    
    return self;
}

/// <summary>
/// The scanner reads a gherkin doc (typically read from a .feature file) and creates a token
/// for each line.
///
/// The tokens are passed to the parser, which outputs an AST (Abstract Syntax Tree).
///
/// If the scanner sees a `#` language header, it will reconfigure itself dynamically to look
/// for  Gherkin keywords for the associated language. The keywords are defined in
/// gherkin-languages.json.
/// </summary>
- (GHToken *)read
{
    NSString * line = (lineNumber < [lines count] ? lines[lineNumber] : nil);
    GHLocation * location = [[GHLocation alloc] initWithLine: ++lineNumber];
    GHGherkinLine * gherkinLine = line ? [[GHGherkinLine alloc] initWithLine: line lineNumber: lineNumber] : nil;
    
    return [[GHToken alloc] initWithGherkinLine: gherkinLine location: location];
}

@end

