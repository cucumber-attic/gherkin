//
//  GHGherkinTokenizationTest.m
//  Gherkin
//
//  Created by Julien Curro on 14/10/15.
//  Copyright © 2015 Gherkin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GHTokenMatcher.h"
#import "GHParser+Extensions.h"

@interface GHGherkinTokenizationTest : XCTestCase

@end

@implementation GHGherkinTokenizationTest

- (void)testSuccessfulParsing:(NSString *)theTestFeatureFile
{
    GHParser * parser = [[GHParser alloc] init];
    id parsingResult = [parser parse: theTestFeatureFile];
    XCTAssertNotNil(parsingResult);
}


- (void)testMultipleFeatures()
{
    GHTokenMatcher * tokenMatcher = [[GHTokenMatcher alloc] init];
    GHParser * parser = [[GHParser alloc] initWithAstBuilder: [[GHAstBuilder alloc] init]];
    var jsonSerializerSettings = new JsonSerializerSettings();
    jsonSerializerSettings.Formatting = Formatting.Indented;
    jsonSerializerSettings.NullValueHandling = NullValueHandling.Ignore;
    
    var parsingResult1 = parser.Parse(new TokenScanner(new StringReader("Feature: Test")), tokenMatcher);
    var astText1 = LineEndingHelper.NormalizeLineEndings(JsonConvert.SerializeObject(parsingResult1, jsonSerializerSettings));
    var parsingResult2 = parser.Parse(new TokenScanner(new StringReader("Feature: Test2")), tokenMatcher);
    var astText2 = LineEndingHelper.NormalizeLineEndings(JsonConvert.SerializeObject(parsingResult2, jsonSerializerSettings));
    
    string expected1 = LineEndingHelper.NormalizeLineEndings(@"{
                                                             ""Tags"": [],
                                                             ""Location"": {
                                                                 ""Line"": 1,
                                                                 ""Column"": 1
                                                             },
                                                             ""Language"": ""en"",
                                                             ""Keyword"": ""Feature"",
                                                             ""Name"": ""Test"",
                                                             ""ScenarioDefinitions"": [],
                                                             ""Comments"": []
                                                             }");
                                                             string expected2 = LineEndingHelper.NormalizeLineEndings(@"{
                                                                                                                      ""Tags"": [],
                                                                                                                      ""Location"": {
                                                                                                                          ""Line"": 1,
                                                                                                                          ""Column"": 1
                                                                                                                      },
                                                                                                                      ""Language"": ""en"",
                                                                                                                      ""Keyword"": ""Feature"",
                                                                                                                      ""Name"": ""Test2"",
                                                                                                                      ""ScenarioDefinitions"": [],
                                                                                                                      ""Comments"": []
                                                                                                                      }");
                                                                                                                      Assert.AreEqual(expected1, astText1);
                                                                                                                      Assert.AreEqual(expected2, astText2);
                                                                                                                      }
                                                                                                                      
                                                                                                                      [Test]
                                                                                                                      public void TestChangeDefaultLanguage()
                                                                                                                      {
                                                                                                                          var tokenMatcher = new TokenMatcher("no");
                                                                                                                          var parser = new Parser(new AstBuilder<Feature>());
                                                                                                                          var jsonSerializerSettings = new JsonSerializerSettings();
                                                                                                                          jsonSerializerSettings.Formatting = Formatting.Indented;
                                                                                                                          jsonSerializerSettings.NullValueHandling = NullValueHandling.Ignore;
                                                                                                                          
                                                                                                                          var parsingResult = parser.Parse(new TokenScanner(new StringReader("Egenskap: i18n support")), tokenMatcher);
                                                                                                                          var astText = LineEndingHelper.NormalizeLineEndings(JsonConvert.SerializeObject(parsingResult, jsonSerializerSettings));
                                                                                                                          
                                                                                                                          string expected = LineEndingHelper.NormalizeLineEndings(@"{
                                                                                                                                                                                  ""Tags"": [],
                                                                                                                                                                                  ""Location"": {
                                                                                                                                                                                      ""Line"": 1,
                                                                                                                                                                                      ""Column"": 1
                                                                                                                                                                                  },
                                                                                                                                                                                  ""Language"": ""no"",
                                                                                                                                                                                  ""Keyword"": ""Egenskap"",
                                                                                                                                                                                  ""Name"": ""i18n support"",
                                                                                                                                                                                  ""ScenarioDefinitions"": [],
                                                                                                                                                                                  ""Comments"": []
                                                                                                                                                                                  }");
                                                                                                                                                                                  XCTAssertEqualObjects(expected, astText);
                                                                                                                                                                                  }

@end
