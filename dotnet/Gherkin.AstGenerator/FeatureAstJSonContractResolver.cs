using System;
using System.Reflection;
using Gherkin.Ast;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Gherkin.AstGenerator
{
    class FeatureAstJSonContractResolver : CamelCasePropertyNamesContractResolver
    {
        protected override string ResolvePropertyName(string propertyName)
        {
            //TODO: naming consolidation between languages

            if (propertyName.Equals("title", StringComparison.InvariantCultureIgnoreCase))
                return "name";

            if (propertyName.Equals("text", StringComparison.InvariantCultureIgnoreCase))
                return "name";

            return base.ResolvePropertyName(propertyName);
        }

        public override JsonContract ResolveContract(Type type)
        {
            var contract = base.ResolveContract(type);

            //TODO: introfuce Node base type and filter for that here
            if (typeof(IHasLocation).IsAssignableFrom(type))
            {
                var objContract = (JsonObjectContract) contract;
                if (!objContract.Properties.Contains("type"))
                    objContract.Properties.AddProperty(new JsonProperty()
                    {
                        PropertyName = "type",
                        ValueProvider = new GetTypeValueProvider(),
                        PropertyType = typeof(string),
                        Readable = true
                    });
            }

            return contract;
        }

        internal class GetTypeValueProvider : IValueProvider
        {
            public void SetValue(object target, object value)
            {
                throw new NotImplementedException();
            }

            public object GetValue(object target)
            {
                return target.GetType().Name;
            }
        }

        protected override JsonConverter ResolveContractConverter(Type objectType)
        {
            var defaultConverter = base.ResolveContractConverter(objectType);
            return defaultConverter;
        }

        class HandleEmptyStepArgumentValueProvider : IValueProvider
        {
            private readonly IValueProvider baseValueProvider;

            public HandleEmptyStepArgumentValueProvider(IValueProvider baseValueProvider)
            {
                this.baseValueProvider = baseValueProvider;
            }

            public void SetValue(object target, object value)
            {
                baseValueProvider.SetValue(target, value);
            }

            public object GetValue(object target)
            {
                var step = (Step)target;
                if (step.Argument is EmptyStepArgument)
                    return null;

                return baseValueProvider.GetValue(target);
            }
        }

        protected override IValueProvider CreateMemberValueProvider(MemberInfo member)
        {
            if (member.Name == "Argument")
            {
                return new HandleEmptyStepArgumentValueProvider(base.CreateMemberValueProvider(member));
            }

            return base.CreateMemberValueProvider(member);
        }
    }
}