using System;
using System.Collections.Generic;
using System.Linq;
using Gherkin.Ast;
// ReSharper disable PossibleMultipleEnumeration

namespace Gherkin.Pickles
{
    public class Compiler
    {
        public List<Pickle> Compile(GherkinDocument gherkinDocument, string path)
        {
            var pickles = new List<Pickle>();
            Feature feature = gherkinDocument.Feature;
            if (feature == null)
            {
                return pickles;
            }

            var featureTags = feature.Tags;
            var backgroundSteps = new PickleStep[0];

            foreach (var scenarioDefinition in feature.Children)
            {
                if (scenarioDefinition is Background)
                {
                    backgroundSteps = PickleSteps(scenarioDefinition, path);
                }
                else if (scenarioDefinition is Scenario)
                {
                    CompileScenario(pickles, backgroundSteps, (Scenario)scenarioDefinition, featureTags, path);
                }
                else {
                    CompileScenarioOutline(pickles, backgroundSteps, (ScenarioOutline)scenarioDefinition, featureTags, path);
                }
            }
            return pickles;
        }

        protected virtual void CompileScenario(List<Pickle> pickles, IEnumerable<PickleStep> backgroundSteps, Scenario scenario, IEnumerable<Tag> featureTags, string path)
        {
            if (!scenario.Steps.Any())
                return;

            var steps = new List<PickleStep>();
            steps.AddRange(backgroundSteps);

            var scenarioTags = new List<Tag>();
            scenarioTags.AddRange(featureTags);
            scenarioTags.AddRange(scenario.Tags);

            steps.AddRange(PickleSteps(scenario, path));

            Pickle pickle = CreatePickle(
                    scenario,
                    scenario.Name,
                    steps,
                    PickleTags(scenarioTags, path),
                    SingletonList(PickleLocation(scenario.Location, path))
            );
            pickles.Add(pickle);
        }

        protected virtual IEnumerable<T> SingletonList<T>(T item)
        {
            return new[] { item };
        }

        protected virtual void CompileScenarioOutline(List<Pickle> pickles, IEnumerable<PickleStep> backgroundSteps, ScenarioOutline scenarioOutline, IEnumerable<Tag> featureTags, string path)
        {
            if (!scenarioOutline.Steps.Any())
                return;

            foreach (var examples in scenarioOutline.Examples)
            {
                if (examples.TableHeader == null) continue;
                var variableCells = examples.TableHeader.Cells;
                foreach (var values in examples.TableBody)
                {
                    var valueCells = values.Cells;

                    var steps = new List<PickleStep>();
                    steps.AddRange(backgroundSteps);

                    var tags = new List<Tag>();
                    tags.AddRange(featureTags);
                    tags.AddRange(scenarioOutline.Tags);
                    tags.AddRange(examples.Tags);

                    foreach(var scenarioOutlineStep in scenarioOutline.Steps)
                    {
                        string stepText = Interpolate(scenarioOutlineStep.Text, variableCells, valueCells);

                        // TODO: Use an Array of location in DataTable/DocString as well.
                        // If the Gherkin AST classes supported
                        // a list of locations, we could just reuse the same classes

                        PickleStep pickleStep = CreatePickleStep(
                                scenarioOutlineStep,
                                stepText,
                                CreatePickleArguments(scenarioOutlineStep.Argument, variableCells, valueCells, path),
                                new[] {
                                        PickleLocation(values.Location, path),
                                        PickleStepLocation(scenarioOutlineStep, path)
                                }
                        );
                        steps.Add(pickleStep);
                    }

                    Pickle pickle = CreatePickle(
                            scenarioOutline,
                            Interpolate(scenarioOutline.Name, variableCells, valueCells),
                            steps,
                            PickleTags(tags, path),
                            new[] {
                                    PickleLocation(values.Location, path),
                                    PickleLocation(scenarioOutline.Location, path)
                            }
                    );

                    pickles.Add(pickle);
                }
            }
        }

        protected virtual Pickle CreatePickle(ScenarioDefinition scenarioDefinition, string name, IEnumerable<PickleStep> steps, IEnumerable<PickleTag> tags, IEnumerable<PickleLocation> locations)
        {
            return new Pickle(name, steps, tags, locations);
        }

        protected virtual PickleStep CreatePickleStep(Step step, string text, IEnumerable<Argument> arguments, IEnumerable<PickleLocation> locations)
        {
            return new PickleStep(text, arguments, locations);
        }

        protected virtual List<Argument> CreatePickleArguments(StepArgument argument, string path)
        {
            var noCells = Enumerable.Empty<TableCell>();
            return CreatePickleArguments(argument, noCells, noCells, path);
        }

        protected virtual List<Argument> CreatePickleArguments(StepArgument argument, IEnumerable<TableCell> variableCells, IEnumerable<TableCell> valueCells, string path)
        {
            var result = new List<Argument>();
            if (argument == null) return result;
            if (argument is DataTable) {
                DataTable t = (DataTable)argument;
                var rows = t.Rows;
                var newRows = new List<PickleRow>(rows.Count());
                foreach(var row in rows)
                {
                    var cells = row.Cells;
                    var newCells = new List<PickleCell>();
                    foreach(var cell in cells)
                    {
                        newCells.Add(
                                new PickleCell(
                                        PickleLocation(cell.Location, path),
                                        Interpolate(cell.Value, variableCells, valueCells)
                                )
                        );
                    }
                    newRows.Add(new PickleRow(newCells));
                }
                result.Add(new PickleTable(newRows));
            } else if (argument is DocString) {
                DocString ds = (DocString)argument;
                result.Add(
                        new PickleString(
                                PickleLocation(ds.Location, path),
                                Interpolate(ds.Content, variableCells, valueCells)
                        )
                );
            } else {
                throw new InvalidOperationException("Unexpected argument type: " + argument);
            }
            return result;
        }

        protected virtual PickleStep[] PickleSteps(ScenarioDefinition scenarioDefinition, string path)
        {
            var result = new List<PickleStep>();
            foreach(var step in scenarioDefinition.Steps)
            {
                result.Add(PickleStep(step, path));
            }
            return result.ToArray();
        }

        protected virtual PickleStep PickleStep(Step step, string path)
        {
            return CreatePickleStep(
                    step,
                    step.Text,
                    CreatePickleArguments(step.Argument, path),
                    SingletonList(PickleStepLocation(step, path))
            );
        }

        protected virtual string Interpolate(string name, IEnumerable<TableCell> variableCells, IEnumerable<TableCell> valueCells)
        {
            int col = 0;
            foreach (var variableCell in variableCells)
            {
                TableCell valueCell = valueCells.ElementAt(col++);
                string header = variableCell.Value;
                string value = valueCell.Value;
                name = name.Replace("<" + header + ">", value);
            }
            return name;
        }

        protected virtual PickleLocation PickleStepLocation(Step step, string path)
        {
            return new PickleLocation(
                    path,
                    step.Location.Line,
                    step.Location.Column + (step.Keyword != null ? step.Keyword.Length : 0)
            );
        }

        protected virtual PickleLocation PickleLocation(Location location, string path)
        {
            return new PickleLocation(path, location.Line, location.Column);
        }

        protected virtual List<PickleTag> PickleTags(List<Tag> tags, string path)
        {
            var result = new List<PickleTag>();
            foreach(var tag in tags)
            {
                result.Add(PickleTag(tag, path));
            }
            return result;
        }

        protected virtual PickleTag PickleTag(Tag tag, string path)
        {
            return new PickleTag(PickleLocation(tag.Location, path), tag.Name);
        }
    }
}
