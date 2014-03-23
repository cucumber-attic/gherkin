using System;
using System.Linq;

namespace Gherkin
{
    public class GherkinDialectProvider
    {
        private readonly GherkinDialect defaultDialect;

        public GherkinDialect DefaultDialect
        {
            get { return defaultDialect; }
        }

        public GherkinDialectProvider(string defaultLanguage = "en")
        {
            defaultDialect = GetDialect(defaultLanguage);
        }

        public GherkinDialect GetDialect(string language)
        {
            //TODO: load from json file
            switch (language)
            {
                case "en":
                    return new GherkinDialect(
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

            throw new NotImplementedException("Language not supported: " + language);
        }
    }
}
