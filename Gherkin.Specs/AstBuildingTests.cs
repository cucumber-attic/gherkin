using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;

namespace Gherkin.Specs
{
    [TestFixture]
    public class AstBuildingTests
    {
        [Test, TestCaseSource(typeof(TestFileProvider), "GetValidTestFiles")]
        public void TestSuccessfulAstBuilding(string testFeatureFile)
        {
            Console.WriteLine(testFeatureFile);

            var featureFileFolder = Path.GetDirectoryName(testFeatureFile);
            Debug.Assert(featureFileFolder != null);
            var expectedAstFile = Path.Combine(featureFileFolder, "expected_result", Path.GetFileName(testFeatureFile) + ".result");

            var parser = new Parser();
            var parsingResult = parser.Parse(testFeatureFile);
            Assert.IsNotNull(parsingResult);

            var astFormatter = new TestAstFormatter();
            var astText = astFormatter.FormatAst(parsingResult);
            Console.WriteLine(astText);

            var expectedAstText = astFormatter.NormalizeLineEndings(File.ReadAllText(expectedAstFile));

            Assert.AreEqual(expectedAstText, astText);
        }
    }
}
