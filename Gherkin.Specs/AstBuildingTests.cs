using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gherkin.Ast;
using Gherkin.AstGenerator;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
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
            var expectedAstFile = testFeatureFile + ".ast.json";

            var astText = AstGenerator.AstGenerator.GenerateAst(testFeatureFile);

            //var x = Newtonsoft.Json.JsonSerializer.Create();
            //var y = (JObject)x.Deserialize(new JsonTextReader(new StringReader(astText)));

            astText = JsonUtility.NormalizeJsonString(astText);

            var expectedFileContent = LineEndingHelper.NormalizeLineEndings(File.ReadAllText(expectedAstFile));
            var expectedAstText = JsonUtility.NormalizeJsonString(expectedFileContent);

            Console.WriteLine(expectedAstText);
            Console.WriteLine(astText);

            Assert.AreEqual(expectedAstText, astText);
        }
    }

    public class JsonUtility
    {
        public static string NormalizeJsonString(string json)
        {
            // Parse json string into JObject.
            var parsedObject = JObject.Parse(json);

            // Sort properties of JObject.
            var normalizedObject = SortPropertiesAlphabetically(parsedObject);

            // Serialize JObject .
            return JsonConvert.SerializeObject(normalizedObject);
        }

        private static JToken SortPropertiesAlphabetically(JToken original)
        {
            var objectValue = original as JObject;
            var arrayValue = original as JArray;
            if (objectValue != null)
            {
                var result = new JObject();
                foreach (var property in objectValue.Properties().ToList().OrderBy(p => p.Name))
                {
                    result.Add(property.Name, SortPropertiesAlphabetically(property.Value));
                }
                return result;
            }
            if (arrayValue != null)
            {
                var result = new JArray();
                foreach (var token in arrayValue)
                {
                    result.Add(SortPropertiesAlphabetically(token));
                }
                return result;
            }
            return original;
        }
    }
}
