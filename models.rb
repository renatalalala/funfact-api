require 'json'
require 'sequel'

DB = Sequel.connect(ENV["DB_URL"])

# create an items table
DB.create_table? :funfacts do
  primary_key :id
  String :fact, unique: true, null: false
  String :category
end

class Model
  @@db = DB[:funfacts]

  def to_hash()
    hash = {}
    self.instance_variables.each {|x|
      hash[x[1..]] = self.instance_variable_get(x)
    }
    return hash
  end

  def render()
    JSON.generate(self.to_hash)
  end

  def save()
    puts @@db.insert(self.to_hash)
  end

  def self.all(start = 0, stop = -1)
    @@db.map { |x|
      puts(x)
      self.new(x)
    }
  end

  def self.filter(&fn)
    self.all.select(&fn)
  end
end

class FunFact < Model

  def self.from_json(json)
    self.new(fact: json["fact"], category: json["category"])
  end

  def initialize(hash)
    @fact = hash[:fact]
    @category = hash[:category]
  end

  def is_category(category)
    puts("#{@category} == #{category}")
    @category == category
  end

end