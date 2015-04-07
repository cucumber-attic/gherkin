using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gherkin.Ast;
using Gherkin.AstGenerator;
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

            var astText = AstGenerator.AstGenerator.GenerateAst(testFeatureFile);
            var expectedAstText = LineEndingHelper.NormalizeLineEndings(File.ReadAllText(expectedAstFile));

            Assert.AreEqual(expectedAstText, astText);
        }
    }
}
