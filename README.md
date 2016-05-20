#Active Record Lite

##Summary
ActiveRecordLite was built to explore how database changes occur using Ruby on Rails' ActiveRecord. This project further demonstrates a knowledge of ActiveRecord's meta-programming usage. This project does not include every feature of ActiveRecord, but contains many popular methods such as the find, where, has_many, belongs_to, has_one_through, and has_many_through of ActiveRecord::Base.

ActiveRecordLite uses SQLite for its database engine.

##Features
The belongs_to #initialize method is written in such a way that an options hash can be passed as an argument so override ActiveRecordLite's default keys.
``` ruby
class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      :foreign_key => options[:foreign_key] || "#{name}_id".to_sym,
      :class_name => options[:class_name] || name.to_s.camelcase,
      :primary_key => options[:primary_key] || :id
    }

    defaults.keys.each do |key|
      self.send("#{key}=", options[key] || defaults[key])
    end
  end
end
```

ActiveRecordLite includes the #where method to demonstrate understanding of how ActiveRecord translates queries into SQL. Parameters are passed as an argument and then used to filter the database through a SQL query.
``` ruby
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
```
