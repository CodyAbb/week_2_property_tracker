require('pry')
require_relative('models/property_tracker')

property1 = PropertyInfo.new({
  'address' => "7 Castle Terrace",
  'value' => 10000,
  'number_of_bedrooms' => 15,
  'build' => "commercial"
  })

property2 = PropertyInfo.new({
  'address' => "1 Princes Street",
  'value' => 2000000,
  'number_of_bedrooms' => 4,
  'build' => "mixed-use"
  })

PropertyInfo.delete_all()
property1.save()
property2.save()

binding.pry
nil
