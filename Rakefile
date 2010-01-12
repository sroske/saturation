require 'rake'

def run(cmd)
  puts cmd
  system cmd
end

current_path = File.dirname(__FILE__)
application = ENV['APPLICATION'] || 'saturation'
configuration = ENV['CONFIGURATION'] || 'Ad Hoc'
version = ENV['VERSION'] || '1.0'
mobileprovision = ENV['PROVISION'] || Dir.glob(File.join(current_path, '*.mobileprovision')).first.to_s
build_dir = File.join(current_path, 'build')
config_build_dir = File.join(build_dir, "#{configuration}-iphoneos")
output_dir = File.join(current_path, "#{application}-#{version}")

desc "Builds the application, modified by CONFIGURATION, the default is 'Ad Hoc Distribution'"
task :build do
  run "rm -rf '#{build_dir}'"
  run "xcodebuild -configuration '#{configuration}' -sdk iphoneos3.0"
end

desc "create a package for distribution, modified by VERSION, the default is '1.0'"
task :package => :build do
  run "cd '#{config_build_dir}' && mkdir Payload && cp -r '#{application}.app' Payload/ && zip -r '#{application}.ipa' Payload"
end

desc "creates a ad-hoc package with the PROVISION file and payload file"
task :adhoc => :package do
  run "mkdir '#{output_dir}' && cp '#{File.join(config_build_dir, application)}.ipa' '#{output_dir}' && cp '#{mobileprovision}' '#{output_dir}' " +
    "&& cd '#{current_path}' && zip -r '#{application}-#{version}.zip' '#{application}-#{version}'"
end

task :default => [:adhoc] do
  run "rm -rf '#{output_dir}'"
  puts "Done"
end
