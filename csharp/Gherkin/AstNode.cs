using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gherkin
{
    public class AstNode : IEnumerable, IEnumerable<object>
    {
        private readonly Dictionary<RuleType, IList<object>> subItems = new Dictionary<RuleType, IList<object>>();
        public RuleType RuleType { get; private set; }

        public Token GetToken(TokenType tokenType)
        {
            return GetSingle<Token>((RuleType)tokenType);
        }

        public T GetSingle<T>(RuleType ruleType)
        {
            return GetItems<T>(ruleType).SingleOrDefault();
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

        public IEnumerable<T> GetItems<T>(RuleType ruleType)
        {
            IList<object> items;
            if (!subItems.TryGetValue(ruleType, out items))
            {
                return Enumerable.Empty<T>();
            }
            return items.Cast<T>();
        } 

        public AstNode(RuleType ruleType)
        {
            this.RuleType = ruleType;
        }

        public IEnumerator<object> GetEnumerator()
        {
            return subItems.SelectMany(si => si.Value).GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}
