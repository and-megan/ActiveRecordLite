require_relative '03_associatable'


module Associatable

  def has_many_through(name, through, source)
    define_method(name) do
      associations = self.send(through)
      unless associations.kind_of?(Array)
        associations.to_a
      end

      has_many_through = []

      associations.each do |object|
        has_many_through =
            has_many_through.concat(object.send(source))
      end

      has_many_through
    end
  end

  def has_one_through(name, through, source)

    define_method(name) do
      through_class = self.send(through)
      through_class.send(source)
    end
  end

end
