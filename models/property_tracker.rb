require('pg')
class PropertyInfo

  attr_reader :id
  attr_accessor :address, :value, :number_of_bedrooms, :build

  def initialize( options )
    @id = options['id'].to_i() if options['id']
    @address = options['address']
    @value = options['value'].to_i
    @number_of_bedrooms = options['number_of_bedrooms'].to_i
    @build = options['build']
  end

  def save()
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql =
      "
      INSERT INTO property_tracker (
        address,
        value,
        number_of_bedrooms,
        build
      ) VALUES ($1, $2, $3, $4) RETURNING id;
      "
    values = [@address, @value, @number_of_bedrooms, @build]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]['id'].to_i
    db.close()
  end

  def self.all()
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql = "SELECT * FROM property_tracker;"
    db.prepare("all", sql)
    properties = db.exec_prepared("all")
    db.close()
    return properties.map { |property_hash| PropertyInfo.new(property_hash) }
  end

  def self.delete_all()
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql = "DELETE FROM property_tracker;"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close()
  end

  def delete()
    db = PG.connect({ dbname: 'property_tracker', host: 'localhost'})
    sql = "DELETE FROM property_tracker WHERE id = $1"
    values = [@id]
    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", values)
    db.close()
  end

  def update()
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql =
      "
      UPDATE property_tracker SET (
        address,
        value,
        number_of_bedrooms,
        build
      ) = (
        $1, $2, $3, $4
      ) WHERE id = $5;
      "
    values = [@address, @value, @number_of_bedrooms, @build, @id]
    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close()
  end

  def find()
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql = "SELECT * FROM property_tracker WHERE id = $1"
    value = [@id]
    db.prepare("find", sql)
    found_property = db.exec_prepared("find", value)[0]
    db.close()
    return PropertyInfo.new(found_property)
  end
end
