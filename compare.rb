# Script for comparing expected files with actual (generated) ones
if ARGV.length < 1
  STDERR.puts "Usage: ruby #{__FILE__} csharp|java|ruby [file ...]"
  exit 1
end

language = ARGV[0]
expected_files = ARGV.length > 1 ? ARGV[1..-1] : Dir['testdata/**/*.feature.{ast,tokens}']

failed = 0
expected_files.each do |expected|
  actual = expected.gsub(/feature/, language)
  diff = `diff --unified --ignore-all-space #{expected} #{actual}`
  if($?.exitstatus == 0)
    # puts "\e[32m#{actual}\e[0m"
  else
    puts "\e[31m#{actual}\e[0m"
    puts diff
    failed +=1
  end
end
puts
puts "\e[32mPassed: #{expected_files.length - failed}\e[0m"
puts "\e[31mFailed: #{failed}\e[0m" if failed > 0
puts
exit(failed == 0 ? 0 : 1)
