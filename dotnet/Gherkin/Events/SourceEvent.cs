namespace Gherkin
{
    public class SourceEvent : IEvent
    {
        private readonly string type = "source";
        public readonly string uri;
        public readonly string data;
        private readonly Media media = new Media ();

        public SourceEvent (string uri, string data)
        {
            this.uri = uri;
            this.data = data;
        }

        internal class Media
        {
            private readonly string encoding = "utf-8";
            private readonly string type = "text/vnd.cucumber.gherkin+plain";
        }
    }
}
