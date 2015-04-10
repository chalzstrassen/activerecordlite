class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method(name.to_sym) { instance_variable_get("@#{name}") }

    end
    names.each do |name|
      define_method("#{name}=".to_sym) { |arg| instance_variable_set("@#{name}", "#{arg}") }
    end

  end
end
