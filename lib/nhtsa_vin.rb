require 'nhtsa_vin/version'
require 'nhtsa_vin/query'
require 'nhtsa_vin/validation'

module NhtsaVin
  extend self

  def get(vin, options={})
    query = NhtsaVin::Query.new(vin, options)
    query.get
    return query
  end
end
