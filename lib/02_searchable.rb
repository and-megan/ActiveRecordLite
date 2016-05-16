require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_query = params.keys.map { |col| "#{col} = ?" }.join(" AND ")

    results = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_query}
    SQL

    parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
