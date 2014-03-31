using System;
using System.Linq;

namespace Gherkin
{
    public class GherkinDialect
    {
        private readonly string[] featureKeywords;
        private readonly string[] backgroundKeywords;
        private readonly string[] scenarioKeywords;
        private readonly string[] scenarioOutlineKeywords;
        private readonly string[] examplesKeywords;
        private readonly string[] givenStepKeywords;
        private readonly string[] whenStepKeywords;
        private readonly string[] thenStepKeywords;
        private readonly string[] andStepKeywords;
        private readonly string[] butStepKeywords;

        private readonly string[] stepKeywords;

        public GherkinDialect(
            string[] featureKeywords, 
            string[] backgroundKeywords, 
            string[] scenarioKeywords,
            string[] scenarioOutlineKeywords,
            string[] examplesKeywords,
            string[] givenStepKeywords,
            string[] whenStepKeywords,
            string[] thenStepKeywords,
            string[] andStepKeywords,
            string[] butStepKeywords)
        {
            this.featureKeywords = featureKeywords;
            this.backgroundKeywords = backgroundKeywords;
            this.scenarioKeywords = scenarioKeywords;
            this.scenarioOutlineKeywords = scenarioOutlineKeywords;
            this.examplesKeywords = examplesKeywords;
            this.givenStepKeywords = givenStepKeywords;
            this.whenStepKeywords = whenStepKeywords;
            this.thenStepKeywords = thenStepKeywords;
            this.andStepKeywords = andStepKeywords;
            this.butStepKeywords = butStepKeywords;

            this.stepKeywords = givenStepKeywords
                .Concat(whenStepKeywords)
                .Concat(thenStepKeywords)
                .Concat(andStepKeywords)
                .Concat(butStepKeywords)
                .ToArray();
        }

        public string[] FeatureKeywords
        {
            get { return featureKeywords; }
        }

        public string[] BackgroundKeywords
        {
            get { return backgroundKeywords; }
        }

        public string[] ScenarioKeywords
        {
            get { return scenarioKeywords; }
        }

        public string[] ScenarioOutlineKeywords
        {
            get { return scenarioOutlineKeywords; }
        }

        public string[] ExamplesKeywords
        {
            get { return examplesKeywords; }
        }

        public string[] StepKeywords
        {
            get { return stepKeywords; }
        }

        public string[] GivenStepKeywords
        {
            get { return givenStepKeywords; }
        }

        public string[] WhenStepKeywords
        {
            get { return whenStepKeywords; }
        }

        public string[] ThenStepKeywords
        {
            get { return thenStepKeywords; }
        }

        public string[] AndStepKeywords
        {
            get { return andStepKeywords; }
        }

        public string[] ButStepKeywords
        {
            get { return butStepKeywords; }
        }

        public string[] GetTitleKeywords(TokenType tokenType)
        {
            switch (tokenType)
            {
                case TokenType.FeatureLine:
                    return FeatureKeywords;
                case TokenType.BackgroundLine:
                    return BackgroundKeywords;
                case TokenType.ScenarioLine:
                    return ScenarioKeywords;
                case TokenType.ScenarioOutlineLine:
                    return ScenarioOutlineKeywords;
                case TokenType.ExamplesLine:
                    return ExamplesKeywords;
            }
            throw new NotSupportedException();
        }
    }
}
