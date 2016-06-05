using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin.Specs
{
    public class TestFileProvider
    {
        public static IEnumerable<string> GetValidTestFiles()
        {
            return GetTestFiles("good");
        }

        public static IEnumerable<string> GetInvalidTestFiles()
        {
            return GetTestFiles("bad");
        }

        private static IEnumerable<string> GetTestFiles(string category)
        {
            string testFileFolder =
                Path.GetFullPath(Path.Combine(TestFolders.InputFolder, "..", "..", "..", "..", @"testdata", category));

            return Directory.GetFiles(testFileFolder, "*.feature");
        }
    }
}
