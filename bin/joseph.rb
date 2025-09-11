#!/usr/bin/env ruby
require 'thor'
require 'awesome_print'
require 'yaml'
require 'erb'

# colors available on https://www.rubydoc.info/github/wycats/thor/Thor/Shell/Color

class RailsDump < Thor
  include Thor::Actions

  def self.current_branch
    `git rev-parse  --abbrev-ref HEAD`.strip
  end

  def self.current_folder
    "dumps/#{current_branch}"
  end

  def self.available_dumps
    files = Dir.glob('dumps/**/*').select { |f| f.end_with?('.sql') }.map do |f|
      f.gsub('dumps/', '')
       .gsub("#{current_branch}/", '')
       .gsub('.sql', '')
    end
    files.join(' | ')
  end

  desc 'restore', 'Restore database postgres. To see options 👉 rails_db help restore'
  option :default, type: :boolean
  option :name, desc: available_dumps
  def restore
    file = find_dump
    kill_other_connections
    command = "psql postgres < #{file}"
    say("Restoring with command:  #{set_color command, :cyan}")
    system(command)
    say("Dump restored!", Thor::Shell::Color::GREEN)
  end

  desc 'dump', 'dump database postgres'
  def dump
    say('Enter a filename. Press Enter for default')
    name = ask('filename:')
    file_name = "dump_#{name}.sql".gsub('_.', '.')
    file_path = "#{self.class.current_folder}/#{file_name}"
    system("mkdir -p #{self.class.current_folder}")

    command = "pg_dump --create --clean --no-owner #{db_name} > #{file_path}"
    say("Dumping with command:  #{set_color command, :cyan}")
    `pg_dump --create --clean --no-owner #{db_name} > #{file_path}`
    say("Created dump file: #{set_color file_path, :green}")
  end

  private

  def find_dump
    if options.key? :name
      find_dump_with_name
    elsif File.exist?("#{self.class.current_folder}/dump.sql") && want_restore_default?
      "#{self.class.current_folder}/dump.sql"
    else
      pick_dump
    end
  end

  def find_dump_with_name
    file = Dir.glob('dumps/**/*').select { |f| f.end_with?('.sql') }.find do |f|
      f == "dumps/#{self.class.current_branch}/#{options[:name]}.sql" || f == "dumps/#{options[:name]}.sql"
    end
    return file if file
    say("dump `#{options[:name]}` not exists", Thor::Shell::Color::RED)
    exit
  end

  def db_name
    yaml = ERB.new(File.read('config/database.yml')).result
    begin # https://stackoverflow.com/a/71192990/3840725
      thing = YAML.load(yaml, aliases: true)
    rescue ArgumentError
      thing = YAML.load(yaml)
    end
    thing['development']['database']
  end

  def want_restore_default?
    return true if options.key? :default

    response = ask('Do you want to restore the default dump? [Y/n]')
    ['y', 'yes', ''].include?(response.downcase)
  end

  def pick_dump
    files = Dir.glob('dumps/**/*').select { |f| f.end_with?('.sql') }
    max_size = files.map(&:size).max
    files.each_with_index do |file, index|
      if file.start_with?("dumps/#{self.class.current_branch}")
        file = file.gsub("dumps/#{self.class.current_branch}", "dumps/#{set_color self.class.current_branch, :green}")
        puts "#{index + 1}. #{file}".ljust(max_size + 10 + self.class.current_branch.size - 2) +  "rails_db restore --name=#{file.gsub('dumps/', '').gsub('.sql', '')}"
      else
        puts "#{index + 1}. #{file}".ljust(max_size + 10) + "rails_db restore --name=#{file.gsub('dumps/', '').gsub('.sql', '')}"
      end

    end

    index = ask('Pick a dump to restore:').to_i - 1
    file = files[index]
    if file.nil? || index < 0
      say('Invalid dump', Thor::Shell::Color::RED)
      return pick_dump
    end
    file
  end

  def kill_other_connections
    say('Detect if database has opened connections')
    say(sql_detect_connections, Thor::Shell::Color::YELLOW)

    processes = `psql postgres --tuples-only -c \"#{sql_detect_connections}\"`.split("\n").map(&:strip)
    if processes.empty?
      say('No connection found', Thor::Shell::Color::YELLOW)
      return
    end
    say('Connections found:')
    processes.each do |process|
      say("\t" + process, Thor::Shell::Color::RED)
    end
    say('Killing other connections')
    say(sql_kill_connections, Thor::Shell::Color::YELLOW)
    `psql postgres --tuples-only -c \"#{sql_kill_connections}\"`
  end

  def sql_detect_connections
    <<-SQL
      SELECT application_name
      FROM pg_stat_activity
      WHERE datname = '#{db_name}'
    SQL
  end

  def sql_kill_connections
    <<-SQL
      SELECT
        pg_terminate_backend(pg_stat_activity.pid)
      FROM
        pg_stat_activity
      WHERE
        pg_stat_activity.datname = '#{db_name}'
        AND pid <> pg_backend_pid();
    SQL
  end
end

RailsDump.start
