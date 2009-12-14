
require "lib/Dependency.rb"

module DDOChargen
  
  class Dependencies < Dependency

    attr_accessor :all_of, :one_of

    def initialize
      @all_of = Array.new
      @one_of = Array.new
    end

    def meets ( level )
      found_one = false
      @one_off.each { |dep| 
        if dep.meets(level)
          found_one = true
        end
      }
      # Optimisation: Return false if one_off failed
      # to verify for this level.
      return false unless found_one
      # Now test the all of.
      @all_of.each { |dep|
        if not dep.meets(level)
          return false
        end
      }
      return true
    end

  end

end
