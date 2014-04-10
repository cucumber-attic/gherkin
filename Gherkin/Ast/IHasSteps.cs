using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public interface IHasSteps
    {
        IEnumerable<Step> Steps { get; }
    }
}