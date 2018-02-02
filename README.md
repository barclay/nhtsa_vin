# NHTSA Vin
----

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

Usage is fairly simple. Provide a VIN, and the gem will return a struct of vehicle data. 

```ruby
query = NhtsaVin.get('1J4BA5H11AL143811')
query.valid? # => true
query.response # => <Struct::NhtsaResponse make="Jeep", model="Grand Cherokee", trim="Laredo/Rocky Mountain Edition", type="SUV", year="2008", size=nil, ... doors=4>
```

In the result no match is found, the result will be `nil`, and `#valid?` will return `false`. 

Vehicle Types
----

For brievity, we're reducing the `Vehicle Type` response to an enumerated set of `["Car", "Truck", "Van", "SUV", "Minivan"]`. We're doing a rough parse of the type and body style to achieve this. It's probably not perfect. 


## License

Licensed under the MIT License.
