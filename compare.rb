# Script for comparing expected files with actual (generated) ones
if ARGV.length < 1
  STDERR.puts "Usage: ruby #{__FILE__} csharp|java|ruby [file ...]"
  exit 1
end

actual_dir = {
  "csharp" => "testdata/good",
  "java"   => "java/target/good",
  "ruby"   => "TODO"
}[ARGV[0]]

expected_files = ARGV.length > 1 ? ARGV[1..-1] : Dir['testdata/good/*.feature.tokens']
status = 0
expected_files.each do |expected|
  actual = File.join(actual_dir, File.basename(expected))
  diff = `diff --unified --ignore-all-space #{expected} #{actual}`
  if($?.exitstatus == 0)
    puts "\e[32m#{actual}\e[0m"
  else
    puts "\e[31m#{actual}\e[0m"
    puts diff
  end
  status |= $?.exitstatus
end
exit(status)
