
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
      if not @one_off.nil? and @one_off.count > 0
        @one_off.each { |dep| 
          if dep.meets(level)
            found_one = true
          end
        }
      else
        # Nothing there to check for.
        found_one = true
      end
      return false if not found_one
      # Now test the all of.
      if not all_of.nil?
        @all_of.each { |dep|
          if not dep.meets(level)
            return false
          end
        }
      end
      return true
    end

    def describe
      str = "Needs All = ["
      @all_of.each { |x| 
        str = str + x.describe + ","
      }
      str += "] Needs One = ["
      @one_of.each { |x|
        str = str + x.describe + ","
      }
      str += "]"
    end

  end

end
