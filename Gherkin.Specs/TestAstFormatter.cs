using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gherkin.Ast;

namespace Gherkin.Specs
{
    class TestAstFormatter
    {
        public string FormatAst(object ast)
        {
            if (ast is Feature)
            {
                var sb = new StringBuilder();
                FormatFeature((Feature)ast, sb);
                return sb.ToString();
            }

            return ast.ToString(); //TODO
        }

        public void FormatFeature(Feature feature, StringBuilder result)
        {
            FormatHasDescription(feature, result);
        }

        private void FormatHasDescription(IHasDescription hasDescription, StringBuilder result)
        {
            result.AppendFormat("{0}: {1}", hasDescription.Keyword, hasDescription.Title);
            if (hasDescription.Description != null)
                result.AppendLine(hasDescription.Description);
        }
    }
}
