require('pg')
class PropertyInfo

  attr_reader :id, :address, :value, :number_of_bedrooms, :build

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

end
