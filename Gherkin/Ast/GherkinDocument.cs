using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin.Ast
{
    public class GherkinDocument
    {
        public Feature Feature { get; private set; }
        public IEnumerable<Comment> Comments { get; private set; }

        public GherkinDocument(Feature feature, Comment[] comments)
        {
            Feature = feature;
            Comments = comments;
        }
    }
}
