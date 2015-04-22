require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options =
        through_options.model_class.assoc_options[source_name]
      search_param = self.send(through_options.foreign_key)

      through_table = through_options.table_name
      source_table = source_options.table_name
      results = DBConnection.execute(<<-SQL, search_param)
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        JOIN
          #{through_table}
        ON
          #{through_table}.#{source_options.foreign_key.to_s} = #{source_table}.id
        WHERE
          #{through_table}.id = ?
      SQL
      hash_arg = {}
      results.first.each do |key, val|
        hash_arg[key.to_sym] = val
      end
      source_options.model_class.new(hash_arg)
    end
  end
end
