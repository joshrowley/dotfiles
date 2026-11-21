require 'rake'
require 'fileutils'

task default: :install

# Directories whose files are linked one by one instead of linking the whole
# directory, because the app also keeps its own runtime files there.
# claude/settings.json -> ~/.claude/settings.json, config/rex/init.lua -> ~/.config/rex/init.lua
NESTED = %w[claude config].freeze

desc 'install dotfiles'
task :install do
  replace_all = false
  files = Dir['*'].reject { |f| %w[Rakefile readme.md].include?(f) || NESTED.include?(f) }
  files += NESTED.flat_map { |dir| Dir["#{dir}/**/*"].select { |f| File.file?(f) } }

  files.each do |file|
    file_path = File.join(ENV['HOME'], ".#{file}")
    puts file_path

    if File.symlink?(file_path) && File.readlink(file_path) == File.expand_path(file)
      puts "already linked ~/.#{file}"
    elsif File.exist?(file_path) || File.symlink?(file_path)
      if replace_all
        puts 'replacing all'
        replace_file(file)
      else
        puts 'overwrite?'
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  FileUtils.rm_rf(File.join(ENV['HOME'], ".#{file}"))
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  target = File.join(ENV['HOME'], ".#{file}")
  FileUtils.mkdir_p(File.dirname(target))
  FileUtils.ln_s(File.expand_path(file), target)
end
