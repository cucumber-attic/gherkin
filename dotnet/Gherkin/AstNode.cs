using System;
using System.Collections.Generic;
using System.Linq;

namespace Gherkin
{
    /// <summary>
    /// Nodes are created by the AstBuilder, and are the building blocks of the AST (Abstract Syntax Tree). 
    /// Every node has a Location that describes the line number and column number in the input file. 
    /// These numbers are 1-indexed.
    /// 
    /// All fields on nodes are strings (except for Location.line and Location.column).
    /// 
    /// The implementation is simple objects without behaviour, only data. 
    /// It's up to the implementation to decide whether to use classes or just basic collections, 
    /// but the AST must have a JSON representation (this is used for testing).
    /// 
    /// Each node in the JSON representation also has a type property with the name of the node type.
    /// </summary>
    public class AstNode
    {
        private readonly Dictionary<RuleType, IList<object>> subItems = new Dictionary<RuleType, IList<object>>();
        public RuleType RuleType { get; private set; }

        public AstNode(RuleType ruleType)
        {
            this.RuleType = ruleType;
        }

        public Token GetToken(TokenType tokenType)
        {
            return GetSingle<Token>((RuleType)tokenType);
        }

        public IEnumerable<Token> GetTokens(TokenType tokenType)
        {
            return GetItems<Token>((RuleType)tokenType);
        }

        public T GetSingle<T>(RuleType ruleType)
        {
            return GetItems<T>(ruleType).SingleOrDefault();
        }

        public IEnumerable<T> GetItems<T>(RuleType ruleType)
        {
            IList<object> items;
            if (!subItems.TryGetValue(ruleType, out items))
            {
                return Enumerable.Empty<T>();
            }
            return items.Cast<T>();
        }

        public void SetSingle<T>(RuleType ruleType, T value)
        {
            subItems[ruleType] = new object[] { value };
        }

        public void AddRange<T>(RuleType ruleType, IEnumerable<T> values)
        {
            foreach (var value in values)
            {
                Add(ruleType, value);
            }
        }

        public void Add<T>(RuleType ruleType, T obj)
        {
            IList<object> items;
            if (!subItems.TryGetValue(ruleType, out items))
            {
                items = new List<object>();
                subItems.Add(ruleType, items);
            }
            items.Add(obj);
        }
    }
}
