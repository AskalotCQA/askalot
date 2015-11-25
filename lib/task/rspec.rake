require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
RSpec::Core::RakeTask.module_eval do
  def pattern
    extras = []
    puts "aaaaaa"
    Rails.application.config.rspec_paths.each do |dir|
      if File.directory? dir
        extras << File.join(dir, 'spec', '**', '*_spec.rb').to_s
      end
    end
    [@pattern] | extras
  end
end