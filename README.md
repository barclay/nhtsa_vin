# NHTSA Vin

[![Gem Version](https://badge.fury.io/rb/nhtsa_vin.svg)](https://badge.fury.io/rb/nhtsa_vin)
[![CircleCI](https://circleci.com/gh/deliv/nhtsa_vin.svg?style=svg)](https://circleci.com/gh/deliv/nhtsa_vin)
[![Maintainability](https://api.codeclimate.com/v1/badges/5096bcc9d52e5253c532/maintainability)](https://codeclimate.com/github/deliv/nhtsa_vin/maintainability)


A ruby gem for fetching and parsing vehicle identification via the vehicle identification number (VIN) from the [NHTSA webservice](https://vpic.nhtsa.dot.gov/api/Home). Note, this gem is not officially affiliated with the NHTSA.

Please note, this gem is currently in early development. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nhsta_vin'
```

And then execute:

    bundle

Or install it yourself as:

    gem install nhsta_vin

## Usage

Usage is fairly simple, there's an exposed `get` class method that you can pass in a VIN string to, and it will return you a NhtsaVin::Query.  

```ruby
query = NhtsaVin.get('1J4BA5H11AL143811') # => <NhtsaVin::Query>
query.valid? # => true
```

The actual data from the webservice is contained in the `response` method. This returns a struct containing the various interesting bits from the API.

```ruby
query.response # => <Struct::NhtsaResponse make="Jeep", model="Grand Cherokee", trim="Laredo/Rocky Mountain Edition", type="SUV", year="2008", size=nil, ... doors=4>
```

They query object also contains helper methods for error handling. For example, in the result no match is found, the result will be `nil`, and `#valid?` will return `false`. 

```ruby
query = NhtsaVin.get('SOME_BAD_VIN') # => <NhtsaVin::Query>
query.valid? # => false
query.error_code # => 11
query.error # => "11- Incorrect Model Year, decoded data may not be accurate"
```


Vehicle Types
----

For brevity, we're reducing the `Vehicle Type` response to an enumerated set of `["Car", "Truck", "Van", "SUV", "Minivan"]`. We're doing a rough parse of the type and body style to achieve this. It's probably not perfect. 


## License

Licensed under the MIT License.
