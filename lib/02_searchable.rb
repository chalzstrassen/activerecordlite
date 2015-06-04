require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map {|key| "#{key} = ?"}.join(" AND ")
    param_values = params.values
    results = DBConnection.execute(<<-SQL, *param_values)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL

    parse_all(results)
  end

# This version of where is chainable and returns an instance of a
# Relation class
  def where2(params)
    Relation.new(self.where(params))
  end
end

class SQLObject
  extend Searchable
  # Mixin Searchable here...
end
