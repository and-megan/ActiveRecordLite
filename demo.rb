require_relative 'lib/active_record_lite'

ENV['DEBUG'] = 'true'

DBConnection.open('db/bikes.sqlite3')

class Bike < SQLObject
  my_attr_accessor :id, :color, :owner_id

  belongs_to :human, foreign_key: :owner_id
  has_one_through :lock, :human, :house
end


class Human < SQLObject
  set_table_name 'humans'
  my_attr_accessor :id, :fname, :lname, :house_id

  has_many :bikes, foreign_key: :owner_id
  belongs_to :house
end


class House < SQLObject
  my_attr_accessor :id, :address

  has_many :humans,
    class_name: 'Humans',
    foreign_key: :house_id,
    primary_key: :id
end

puts 'simply find queries:'
puts '-------------------'
bike = Bike.find(2)
puts "bike = Bike.find(2)       => #{bike.inspect}"
puts "bike.name                => #{bike.color}"

puts

human = Human.find(1)
puts "human = Human.find(1)   => #{human.inspect}"
puts "human.fname             => #{human.fname}"

puts

puts 'belongs_to associations:'
puts '-----------------------'
puts "bike.human               => #{bike.human.inspect}"
puts "bike.human.fname:        => #{bike.human.fname}"
puts "human.house.address:    => #{human.house.address}"

puts

puts 'has_many associations:'
puts '---------------------'
puts "human.bikes              => #{human.bikes.inspect}"

puts

puts 'has_one_through associations:'
puts '----------------------------'
puts "bike.house               => #{bike.house.inspect}"
puts "bike.house.address:      => #{bike.house.address}"
