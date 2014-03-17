task :default => "lib/gherkin/parser.rb"

file "lib/gherkin/parser.rb" => ["../gherkin.berp", "gherkin-ruby.razor"] do |t|
  grammar = t.prerequisites.find {|p| p =~ /\.berp$/}
  template = t.prerequisites.find {|p| p =~ /\.razor$/}
  sh "mono ../bin/berp.exe -g #{grammar} -t #{template} -o #{t.name}"
end
