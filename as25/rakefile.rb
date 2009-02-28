def to_class_name(file)
  parts = file.split('/')
  parts.shift
  name = parts.pop
  name.split('.').shift
end

def to_var_name(file)
  parts = file.split('/')
  parts.shift
  name = parts.pop
  name = name.split('.').shift
  name[0, 1].downcase + name[1, name.size]
end

Dir.glob('src/**/**/*').each do |file|
  if(!File.directory?(file))
    puts "private var #{to_var_name file}:#{to_class_name file};"
  end
end

