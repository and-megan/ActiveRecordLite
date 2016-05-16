require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'


class SQLObject


  def self.columns
    return @columns if @columns
    results = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    @columns = results.first.map { |result| result.to_sym}
  end

  def self.finalize!
    self.columns.each do |col|
      define_method("#{col}") do
        attributes[col]
      end

      define_method("#{col}=") do |value|
        attributes[col] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    ivar = self.to_s.split(/(?=[A-Z])/).join('_').downcase
    @table_name = "#{ivar}s"
  end

  def self.all
    results = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    self.parse_all(results.drop(1))
  end

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end

  def self.find(id)
    result = DBConnection.execute2(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{self.table_name}.id = ?
    SQL

    self.parse_all(result.drop(1)).first
  end

  def initialize(params = {})
    params.each do |param, val|
      param = param.to_sym
      raise "unknown attribute '#{param}'" unless self.class.columns.include?(param)
      self.send("#{param}=", val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |name| self.send("#{name}") }
  end

  def insert
     columns = self.class.columns.drop(1)
     num_questions = columns.count
     col_names = columns.map { |col| col.to_sym }.join(", ")
     question_marks = (["?"] * num_questions).join(", ")

     DBConnection.execute(<<-SQL, *attribute_values.drop(1))
       INSERT INTO
         #{self.class.table_name} (#{col_names})
       VALUES
         (#{question_marks})
     SQL
     self.id = DBConnection.last_insert_row_id
   end

  def update
    set_line = self.class.columns.drop(1).map { |col| "#{col} = ?"}.join(", ")
    DBConnection.execute2(<<-SQL, *attribute_values.rotate)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = ?
    SQL
  end

  def save
    if id == nil
      insert
    else
      update
    end
  end

end
