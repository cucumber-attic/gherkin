task :default => "lib/gherkin/parser.rb"

file "lib/gherkin/parser.rb" => ["../gherkin.berp", "gherkin-ruby.razor", "../bin/berp.exe"] do |t|
  berp = t.prerequisites.find {|p| p =~ /\.exe$/}
  grammar = t.prerequisites.find {|p| p =~ /\.berp$/}
  template = t.prerequisites.find {|p| p =~ /\.razor$/}
  sh "mono #{berp} -g #{grammar} -t #{template} -o #{t.name}"
end
