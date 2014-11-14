using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gherkin.Ast;
using NUnit.Framework;

namespace Gherkin.Specs
{
    [TestFixture]
    public class AstBuildingTests
    {
        [Test, TestCaseSource(typeof(TestFileProvider), "GetValidTestFiles")]
        public void TestSuccessfulAstBuilding(string testFeatureFile)
        {
            var featureFileFolder = Path.GetDirectoryName(testFeatureFile);
            Debug.Assert(featureFileFolder != null);
            var expectedAstFile = testFeatureFile + ".ast";

            var parser = new Parser();
            var parsingResult = (Feature)parser.Parse(testFeatureFile);
            Assert.IsNotNull(parsingResult);

            var astFormatter = new TestAstFormatter();
            var astText = astFormatter.FormatAst(parsingResult);
            var expectedAstText = LineEndingHelper.NormalizeLineEndings(File.ReadAllText(expectedAstFile));

            Assert.AreEqual(expectedAstText, astText);
        }
    }
}
