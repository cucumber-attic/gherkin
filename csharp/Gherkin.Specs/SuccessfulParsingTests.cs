using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;

namespace Gherkin.Specs
{
    [TestFixture]
    public class SuccessfulParsingTests
    {
        [Test, TestCaseSource(typeof(TestFileProvider), "GetValidTestFiles")]
        public void TestSuccessfulParsing(string testFeatureFile)
        {
            Console.WriteLine(testFeatureFile);

            var parser = new Parser();
            var parsingResult = parser.Parse(testFeatureFile);
            Assert.IsNotNull(parsingResult);
        }
    }
}
