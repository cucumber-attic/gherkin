using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gherkin.Ast;
using NUnit.Framework;

namespace Gherkin.Specs
{
    [TestFixture]
    public class GherkinDialectTests
    {
        [Test]
        public void ShouldThrowNoSuchLanguageExceptionForInvalidLanguage()
        {
            var x = new GherkinDialectProvider();
            
            Assert.Throws<NoSuchLanguageException>(() => x.GetDialect("nosuchlang", new Location(1, 2)));            
        }

        [Test]
        public void ShouldThrowNoSuchLanguageExceptionForInvalidDefaultLanguage()
        {
            var x = new GherkinDialectProvider("nosuchlang");
            
            Assert.Throws<NoSuchLanguageException>(() => { var dialect =  x.DefaultDialect;});
        }

        [Test]
        public void ShouldThrowNoSuchLanguageExceptionForInvalidLanguageWithoutLocation()
        {
            var x = new GherkinDialectProvider();
            Assert.Throws<NoSuchLanguageException>(() => x.GetDialect("nosuchlang", null));            
        }
    }
}
