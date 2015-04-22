require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'
# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      :class_name => name.to_s.camelcase,
      :foreign_key => "#{name}_id".to_sym,
      :primary_key => :id
        }
    merged = defaults.merge(options)
    @foreign_key = merged[:foreign_key]
    @primary_key = merged[:primary_key]
    @class_name = merged[:class_name]
  end

end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      :class_name => name.to_s.singularize.camelcase,
      :foreign_key => "#{self_class_name.underscore}_id".to_sym,
      :primary_key => :id
    }
    merged = defaults.merge(options)
    @foreign_key = merged[:foreign_key]
    @primary_key = merged[:primary_key]
    @class_name = merged[:class_name]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(name) do
      model = options.model_class
      model.where({:id => self.id}).first
    end
    assoc_options[name] = options
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do
      foreign_key_id = options.send(:foreign_key)
      model = options.model_class
      model.where({foreign_key_id => self.id})
    end

  end

  def assoc_options
    @assoc_options ||= {}
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end

end

class SQLObject
  extend Associatable
  # Mixin Associatable here...
end
