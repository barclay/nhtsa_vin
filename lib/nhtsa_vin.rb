require 'nhtsa_vin/version'
require 'nhtsa_vin/query'
require 'nhtsa_vin/validation'

module NhtsaVin
  extend self

  def get(vin, options={})
    query = NhtsaVin::Query.new(vin, options)
    query.get
    query
  end
  
  def validate(vin, options={})
    NhtsaVin::Validation.new(vin)
  end
end
