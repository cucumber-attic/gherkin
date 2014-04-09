# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

$:.unshift File.expand_path("../lib", __FILE__)

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.ruby_opts  = %w[-r./spec/coverage -w]
  t.rspec_opts = %w[--color]
end

require_relative 'spec/capture_warnings'
include CaptureWarnings
namespace :spec do
  task :warnings do
    report_warnings do
      Rake::Task['spec'].invoke
    end
  end
end

task default: ['lib/gherkin/parser.rb', 'spec:warnings']

file "lib/gherkin/parser.rb" => ["../gherkin.berp", "gherkin-ruby.razor", "../bin/berp.exe"] do |t|
  berp = t.prerequisites.find {|p| p =~ /\.exe$/}
  grammar = t.prerequisites.find {|p| p =~ /\.berp$/}
  template = t.prerequisites.find {|p| p =~ /\.razor$/}
  sh "#{berp} -g #{grammar} -t #{template} -o #{t.name}"
end
