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

    Relation.new(parse_all(results))
  end
end

class SQLObject
  extend Searchable
  # Mixin Searchable here...
end
