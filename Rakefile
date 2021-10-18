require 'rake'

task default: :install

desc 'install dotfiles'
task :install do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile readme.md].include?(file)

    file_path = File.join(ENV['HOME'], ".#{file}")
    puts file_path

    if File.exist?(file_path)
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
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
