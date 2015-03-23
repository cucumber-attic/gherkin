using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.Script.Serialization;

namespace Gherkin
{
    public interface IGherkinDialectProvider
    {
        GherkinDialect DefaultDialect { get; }
        GherkinDialect GetDialect(string language);
    }

    public class GherkinDialectProvider : IGherkinDialectProvider
    {
        protected class GherkinLanguageSetting
        {
            // ReSharper disable InconsistentNaming
            public string name;
            public string native;
            public string[] feature;
            public string[] background;
            public string[] scenario;
            public string[] scenarioOutline;
            public string[] examples;
            public string[] given;
            public string[] when;
            public string[] then;
            public string[] and;
            public string[] but;
            // ReSharper restore InconsistentNaming
        }

        private readonly Lazy<GherkinDialect> defaultDialect;

        public GherkinDialect DefaultDialect
        {
            get { return defaultDialect.Value; }
        }

        public GherkinDialectProvider(string defaultLanguage = "en")
        {
            defaultDialect = new Lazy<GherkinDialect>(() => GetDialect(defaultLanguage));
        }

        public virtual GherkinDialect GetDialect(string language)
        {
            var gherkinLanguageSettings = LoadLanguageSettings();
            return GetDialect(language, gherkinLanguageSettings);
        }

        protected virtual Dictionary<string, GherkinLanguageSetting> LoadLanguageSettings()
        {
            string languagesFile = Path.GetFullPath("dialects.json");
            if (!File.Exists(languagesFile))
            {
                throw new InvalidOperationException("Gherkin language settings file not found: " + languagesFile);
            }
            var languagesFileContent = File.ReadAllText(languagesFile);

            return ParseJsonContent(languagesFileContent);
        }

        protected Dictionary<string, GherkinLanguageSetting> ParseJsonContent(string languagesFileContent)
        {
            var jsonSerializer = new JavaScriptSerializer();
            return jsonSerializer.Deserialize<Dictionary<string, GherkinLanguageSetting>>(languagesFileContent);
        }

        protected virtual GherkinDialect GetDialect(string language, Dictionary<string, GherkinLanguageSetting> gherkinLanguageSettings)
        {
            GherkinLanguageSetting languageSettings;
            if (!gherkinLanguageSettings.TryGetValue(language, out languageSettings))
                throw new NotSupportedException("Language not supported: " + language);

            return CreateGherkinDialect(language, languageSettings);
        }

        protected GherkinDialect CreateGherkinDialect(string language, GherkinLanguageSetting languageSettings)
        {
            return new GherkinDialect(
                language,
                ParseTitleKeywords(languageSettings.feature),
                ParseTitleKeywords(languageSettings.background),
                ParseTitleKeywords(languageSettings.scenario),
                ParseTitleKeywords(languageSettings.scenarioOutline),
                ParseTitleKeywords(languageSettings.examples),
                ParseStepKeywords(languageSettings.given),
                ParseStepKeywords(languageSettings.when),
                ParseStepKeywords(languageSettings.then),
                ParseStepKeywords(languageSettings.and),
                ParseStepKeywords(languageSettings.but)
            );
        }

        private string[] ParseStepKeywords(string[] stepKeywords)
        {
            return stepKeywords;
        }

        private string[] ParseTitleKeywords(string[] keywords)
        {
            return keywords;
        }

        protected static GherkinDialect GetFactoryDefault()
        {
            return new GherkinDialect(
                "en",
                new[] {"Feature"},
                new[] {"Background"},
                new[] {"Scenario"},
                new[] {"Scenario Outline", "Scenario Template"},
                new[] {"Examples", "Scenarios"},
                new[] {"* ", "Given "},
                new[] {"* ", "When " },
                new[] {"* ", "Then " },
                new[] {"* ", "And " },
                new[] {"* ", "But " });
        }
    }
}
