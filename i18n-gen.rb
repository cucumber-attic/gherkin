require 'json'

def unicode_escape(word)
  word = word.unpack("U*").map do |c|
    if c > 127 || c == 32
      "\\u%04x" % c
    else
      c.chr
    end
  end.join
end

i18n = JSON.parse(File.read(File.dirname(__FILE__) + '/../i18n.json'))

i18n.each do |lang, map|
  File.open("src/main/resources/gherkin/#{lang}.properties", "wb") do |lang_file|
    steps = []
    map.each do |key,translation|
      if key =~ /(given|when|then|and|but)/
        keywords = translation.split("|")
        keywords = keywords.map do |keyword|
          if(keyword =~ /(.*)<$/)
            steps.push($1)
          else
            steps.push("#{keyword} ")
          end
        end
      else
        lang_file.puts "#{key}=#{unicode_escape(translation)}"
      end
    end
    lang_file.puts "steps=#{unicode_escape(steps.join('|'))}"
  end
end
