require 'json'

module Gherkin
  DIALECT_FILE_PATH = File.expand_path("dialects.json", File.dirname(__FILE__))
  DIALECTS = JSON.parse File.read(DIALECT_FILE_PATH)

  class Dialect
    def self.for(name)
      spec = DIALECTS[name]
      return nil unless spec
      new(spec)
    end

    def initialize(spec)
      @spec = spec
    end

    def method_missing(name, *args, &block)
      @spec.fetch(normalise_method_name name.to_s)
    rescue KeyError
      super
    end

    def respond_to_missing?(name, *args, &block)
      @spec.keys.include?(normalise_method_name name.to_s) || super
    end

    private

    def normalise_method_name(original)
      first, *rest = original.split("_")
      first + rest.map(&:capitalize).join
    end
  end
end
