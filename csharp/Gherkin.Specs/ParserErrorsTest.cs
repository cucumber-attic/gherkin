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
    public class ParserErrorsTest
    {
        [Test, TestCaseSource(typeof(TestFileProvider), "GetInvalidTestFiles")]
        public void TestParserErrors(string testFeatureFile)
        {
            var featureFileFolder = Path.GetDirectoryName(testFeatureFile);
            Debug.Assert(featureFileFolder != null);
            var expectedErrorsFile = testFeatureFile + ".errors";

            try
            {
                var parser = new Parser();
                parser.Parse(testFeatureFile);
                Assert.Fail("ParserException expected");
            }
            catch (ParserException parserException)
            {
                var errorsText = LineEndingHelper.NormalizeLineEndings(parserException.Message);

                var expectedErrorsText = LineEndingHelper.NormalizeLineEndings(File.ReadAllText(expectedErrorsFile));
                Assert.AreEqual(expectedErrorsText, errorsText);
            }

        }
    }
}
