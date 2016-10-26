namespace Gherkin.AstGenerator
{
	class Attachment
	{
        readonly string data;
        readonly SourceRef source;

        public Attachment (SourceRef source, string data)
        {
            this.source = source;
            this.data = data;
        }

        internal class Location
		{
			readonly int column;
			readonly int line;

			public Location (int line, int column)
			{
				this.line = line;
				this.column = column;
			}
		}

        internal class SourceRef
        {
            readonly string featureFilePath;
            readonly Location location;

            public SourceRef (string featureFilePath, Location location)
            {
                this.featureFilePath = featureFilePath;
                this.location = location;
            }
        }
    }
}