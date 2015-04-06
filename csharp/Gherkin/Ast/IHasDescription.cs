using System;
using System.Linq;

namespace Gherkin.Ast
{
    public interface IHasDescription
    {
        string Keyword { get; }
        string Title { get; }
        string Description { get; }
    }
}