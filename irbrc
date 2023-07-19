puts "-------------------"
puts "Loadind .irbrc file"

if defined?(Rails)
  def toto
    puts "toto"
  end
end

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
