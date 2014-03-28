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
        public IEnumerable<string> GetValidTestFiles()
        {
            string testFileFolder = Path.GetFullPath(Path.Combine(TestFolders.InputFolder, @"..\..\..\..\testdata"));

            return Directory.GetFiles(testFileFolder, "*.feature");
        }

    }
}
