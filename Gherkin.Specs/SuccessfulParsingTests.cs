using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gherkin.AstGenerator;
using Gherkin.Ast;
using NUnit.Framework;
using Newtonsoft.Json;

namespace Gherkin.Specs
{
    [TestFixture]
    public class SuccessfulParsingTests
    {
        [Test, TestCaseSource(typeof(TestFileProvider), "GetValidTestFiles")]
        public void TestSuccessfulParsing(string testFeatureFile)
        {
            var parser = new Parser();
            var parsingResult = parser.Parse(testFeatureFile);
            Assert.IsNotNull(parsingResult);
        }

        [Test]
        public void TestMultipleFeatures()
        {
            var tokenMatcher = new TokenMatcher();
            var astBuilder = new AstBuilder<Feature>();
            var parser = new Parser<Feature>();
            var jsonSerializerSettings = new JsonSerializerSettings();
            jsonSerializerSettings.Formatting = Formatting.Indented;
            jsonSerializerSettings.NullValueHandling = NullValueHandling.Ignore;

            var parsingResult1 = parser.Parse(new TokenScanner(new StringReader("Feature: Test")), tokenMatcher, astBuilder);
            var astText1 = LineEndingHelper.NormalizeLineEndings(JsonConvert.SerializeObject(parsingResult1, jsonSerializerSettings));
            var parsingResult2 = parser.Parse(new TokenScanner(new StringReader("Feature: Test2")), tokenMatcher, astBuilder);
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
    }
}
