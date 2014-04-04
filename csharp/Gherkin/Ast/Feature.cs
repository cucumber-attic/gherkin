using System;
using System.Linq;

namespace Gherkin.Ast
{
    public class Feature : IHasLocation, IHasDescription, IHasTags
    {
        public Tag[] Tags { get; private set; }
        public Location Location { get; private set; }
        public string Language { get; private set; }
        public string Keyword { get; private set; }
        public string Title { get; private set; }
        public string Description { get; private set; }
        public ScenarioDefinition[] ScenarioDefinitions { get; private set; }
    }

    public class Background : IHasLocation, IHasDescription, IHasSteps
    {
        public Location Location { get; private set; }
        public string Keyword { get; private set; }
        public string Title { get; private set; }
        public string Description { get; private set; }
        public Step[] Steps { get; private set; }
    }

    public abstract class ScenarioDefinition : IHasLocation, IHasDescription, IHasSteps, IHasTags
    {
        public Tag[] Tags { get; private set; }
        public Location Location { get; private set; }
        public string Keyword { get; private set; }
        public string Title { get; private set; }
        public string Description { get; private set; }
        public Step[] Steps { get; private set; }

        protected ScenarioDefinition(Tag[] tags, Location location, string keyword, string title, string description, Step[] steps)
        {
            Tags = tags;
            Location = location;
            Keyword = keyword;
            Title = title;
            Description = description;
            Steps = steps;
        }
    }

    public class Scenario : ScenarioDefinition
    {
        public Scenario(Tag[] tags, Location location, string keyword, string title, string description, Step[] steps) : base(tags, location, keyword, title, description, steps)
        {
        }
    }

    public class ScenarioOutline : ScenarioDefinition
    {
        public Examples[] Examples { get; private set; }

        public ScenarioOutline(Tag[] tags, Location location, string keyword, string title, string description, Step[] steps, Examples[] examples) : base(tags, location, keyword, title, description, steps)
        {
            Examples = examples;
        }
    }

    public class Examples : IHasLocation, IHasDescription, IHasRows, IHasTags
    {
        public Tag[] Tags { get; private set; }
        public Location Location { get; private set; }
        public string Keyword { get; private set; }
        public string Title { get; private set; }
        public string Description { get; private set; }
        public TableRow Header { get; private set; }
        public TableRow[] Rows { get; private set; }
    }

    public class Step : IHasLocation
    {
        public Location Location { get; private set; }
        public string Keyword { get; private set; }
        public string Value { get; private set; }
        public StepArgument StepArgument { get; private set; }

        public Step(string keyword, string value, StepArgument stepArgument, Location location)
        {
            Location = location;
            Keyword = keyword;
            Value = value;
            StepArgument = stepArgument;
        }
    }

    public abstract class StepArgument
    {
        
    }

    public class DataTable : StepArgument, IHasLocation, IHasRows
    {
        public Location Location { get; private set; }
        public TableRow[] Rows { get; private set; }
    }

    public class DocString : StepArgument, IHasLocation
    {
        public Location Location { get; private set; }
        public string ContentType { get; private set; }
        public string Content { get; private set; }
    }

    public class EmptyStepArgument : StepArgument
    {
        
    }

    public class Tag : IHasLocation
    {
        public Location Location { get; private set; }
        public string Value { get; private set; }

        public Tag(string value, Location location)
        {
            Value = value;
            Location = location;
        }
    }

    public interface IHasTags
    {
        Tag[] Tags { get; }
    }

    public class TableRow : IHasLocation
    {
        public Location Location { get; private set; }
        public TableCell[] Cells { get; private set; }

    }

    public class TableCell : IHasLocation
    {
        public Location Location { get; private set; }
        public string Value { get; private set; }
    }

    public interface IHasRows
    {
        TableRow[] Rows { get; }
    }

    public interface IHasSteps
    {
        Step[] Steps { get; }
    }

    public interface IHasDescription
    {
        string Keyword { get; }
        string Title { get; }
        string Description { get; }
    }

    public interface IHasLocation
    {
        Location Location { get; }
    }

    public class Location
    {
        public string FilePath { get; private set; }
        public int Line { get; private set; }
        public int Column { get; private set; }
    }
}
