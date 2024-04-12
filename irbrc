puts "-------------------"
puts "Loadind .irbrc file"

puts "Adding Object#local_methods"
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

puts "Adding pbcopy(_)"
def pbcopy(data)
  IO.popen('pbcopy', 'w') { _1.write(data) }
  "Data copied in your clipboard"
end

# Source https://twitter.com/RubyCademy/status/1689367977068466177
# and    https://twitter.com/RubyCademy/status/1740023192851231173

class String
  def red;  "\e[31m#{self}\e[0m" end
  def cyan; "\e[36m#{self}\e[0m" end
end

if defined?(Rails)
  project_name = File.basename(Dir.pwd).cyan
  environment  = ENV['RAILS_ENV'].red

  prompt = "#{project_name}[#{environment}]"

  IRB.conf[:PROMPT] ||= {}
  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{prompt} %03n > ", # myproject[]staging 001 >
    :PROMPT_S => "#{prompt} %03n * ", # myproject[]staging 001 *
    :PROMPT_C => "#{prompt} %03n ? ", # myproject[]staging 001 ?
    :RETURN   => "=> %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS

  module Rails::ConsoleMethods
    alias r reload!
  end
end
