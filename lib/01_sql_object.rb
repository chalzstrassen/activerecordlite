require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    results = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    results.first.map(&:to_sym)
  end

  def self.finalize!
    @table_name = "#{self.to_s.tableize}" if @table_name.nil?

    columns.each do |column|
      define_method(column) { attributes[column] }
      define_method("#{column}=") do |arg|
        attributes[column] = arg
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    return [] if results.empty?
    all_objects = []
    results.each do |hash|
      keys = hash.keys
      hash_arg = {}
      keys.each do |key|
        hash_arg[key.to_sym] = hash[key]
      end
      all_objects << self.new(hash_arg)
    end

    all_objects
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL

    return nil if result.empty?
    hash_arg = {}
    result[0].each do |key, value|
      hash_arg[key.to_sym] = value
    end
    self.new(hash_arg)
  end

  def initialize(params = {})
    params.each do |key, value|
      raise "unknown attribute '#{key}'" if !self.class.columns.include?(key)
      attributes[key] = value
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |column|
      self.send(column)
    end
  end

  def insert
    columns = self.class.columns
    col_names = columns.join(", ")
    question_marks = (["?"] * columns.length).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_line = self.class.columns.map { |column| "#{column} = ?" }.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = ?
    SQL

  end

  def save
    if id.nil?
      insert
    else
      update
    end
  end
end
