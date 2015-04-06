using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public interface IHasTags
    {
        IEnumerable<Tag> Tags { get; }
    }
}