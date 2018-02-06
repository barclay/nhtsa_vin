# frozen_string_literal: true

module NhtsaVin
  class Validation
    TRANSLITERATIONS = { 'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7,
                         'H': 8, 'J': 1, 'K': 2, 'L': 3, 'M': 4, 'N': 5, 'P': 7,
                         'R': 9, 'S': 2, 'T': 3, 'U': 4, 'V': 5, 'W': 6, 'X': 7,
                         'Y': 8, 'Z': 9 }.freeze

    WEIGHTS = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2].freeze

    attr_reader :vin, :valid, :wmi, :vds, :check, :plant, :seq, :error

    ##
    # Validates a VIN that it fits both the definition, and that the checksum
    # is valid.
    #
    def initialize(vin)
      @valid = false
      if vin.nil?
        @error = 'Blank VIN provided'
        return
      end
      @vin = vin.strip
      if !regex
        @error = 'Invalid VIN format'
        return
      elsif checksum != @check
        @error = "VIN checksum digit #{@check} failed "\
                 "to calculate (expected #{checksum})"
        return
      else
        @valid = true
      end
    end

    def valid?
      @valid
    end

    private

    def regex
      match_data = %r{
        ^(?<wmi>[A-HJ-NPR-Z\d]{3})
         (?<vds>[A-HJ-NPR-Z\d]{5})
         (?<check>[\dX])
         (?<vis>(?<year>[A-HJ-NPR-Z\d])
         (?<plant>[A-HJ-NPR-Z\d])
         (?<seq>[A-HJ-NPR-Z\d]{6}))$
      }ix.match(@vin)

      if match_data
        @wmi = match_data[:wmi]
        @vds = match_data[:vds]
        @check = match_data[:check]
        @vis = match_data[:vis]
        @plant = match_data[:plant]
        @seq = match_data[:seq]
      end
      match_data
    end

    def checksum
      m = @vin.chars.each_with_index.map do |char, i|
        if char !~ /\D/
          char.to_i * WEIGHTS[i]
        else
          TRANSLITERATIONS[char.upcase.to_sym] * WEIGHTS[i]
        end
      end
      checksum = m.inject(0, :+) % 11
      checksum == 10 ? 'X' : checksum.to_s
    end
  end
end
