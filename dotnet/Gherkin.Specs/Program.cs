using NUnit.Common;
using NUnitLite;
using System;
using System.Reflection;

namespace Gherkin.Specs
{
    public class Program
    {
        public static int Main(string[] args)
        {
            #if NET452
            
            return new AutoRun(typeof(Program).GetTypeInfo().Assembly)
                      .Execute(args, new ExtendedTextWrapper(Console.Out), Console.In);
            
            #endif
            
            #if NETSTANDARD1_5
            
            
            var assembly = typeof(Program).GetTypeInfo().Assembly
            ;
            
            return new AutoRun(assembly)
                      .Execute(args, new ExtendedTextWrapper(Console.Out), Console.In);
            
            #endif
            
            
            return 0;
        }
    }
}
