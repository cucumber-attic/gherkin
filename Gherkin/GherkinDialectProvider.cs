using System;
using System.Linq;

namespace Gherkin
{
    public class GherkinDialectProvider
    {
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
            //TODO: load from json file
            switch (language)
            {
                case "en":
                    return new GherkinDialect(
                        language,
                        new[] {"Feature"},
                        new[] {"Background"},
                        new[] {"Scenario"},
                        new[] {"Scenario Outline", "Scenario Template"},
                        new[] {"Examples", "Scenarios"},
                        new[] {"Given "},
                        new[] {"When "},
                        new[] {"Then "},
                        new[] {"And ", "* "},
                        new[] {"But "});
                case "no":
                    return new GherkinDialect(
                        language,
                        new[] {"Egenskap"},
                        new[] {"Bakgrunn"},
                        new[] {"Scenario"},
                        new[] {"Scenariomal", "Abstrakt Scenario"},
                        new[] {"Eksempler"},
                        new[] {"Gitt "},
                        new[] {"Når "},
                        new[] {"Så "},
                        new[] {"Og ", "* "},
                        new[] {"Men "});
            }

            throw new NotSupportedException("Language not supported: " + language);
        }
    }
}
