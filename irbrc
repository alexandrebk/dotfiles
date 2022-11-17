puts "Loadind .irbrc file"

if defined?(Rails)
  def toto
    puts "toto"
  end
end

if defined?(Pry)
  Pry.start
  exit
end

class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end
