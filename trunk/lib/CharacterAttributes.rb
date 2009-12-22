
require "lib/Attributes.rb"
require "lib/ChargenError.rb"

module DDOChargen

  class CharacterAttributes

    attr_accessor :maxbuypoints
    attr_reader :increases, :buypoints, :base

    def initialize
      @base = Attributes.new()
      @increases = Attributes.new(0, 0, 0, 0, 0, 0)
      @maxbuypoints = 28
      @buypoints = 0
    end

    def calculate_buypoints
      @buypoints = 0
      @increases.names.each { |item|
        base = @base.by_name(item)
        value = @increases.by_name(item)
        value.times { |point| 
          mod = ((base + point) - 10) / 2
          # If its less than or equal to zero (i.e. -2) then the cost is 1.
          if mod <= 0
            mod = 1
          end
          # If the race has a better base stat of +2, +2 costs only start when would have
          # +3 costs, and +3 costs would start when we would have +4 costs etc.
          # So substract the mod of the base improvement off the actually points spent.
          ep = base - 8
          if ep > 0 and mod > 1
            mod = mod - (ep / 2)
          end
          @buypoints += mod
        }
      }
    end
    
    def base=(b)
      @base = b
      calculate_buypoints()
    end

    def can_increase? ( what ) 
      wouldbe = @base.by_name(what) + @increases.by_name(what) + 1
      if wouldbe > @base.by_name(what)+10
        return false
      end
      # Calculate what it would cost to increase this one further.
      mod = get_mod(what)
      if mod <= 0 then
        mod = 1
      end
      return ((@buypoints + mod) <= @maxbuypoints)
    end
    
    def can_decrease? ( what )
      return (@increases.by_name(what) > 0)
    end

    def increase ( what )
      if not can_increase?(what) then
        raise ChargenError.new("Cannot increase this stat any further!")
      end
      @increases.increase(what)
      calculate_buypoints()
    end

    def decrease ( what ) 
      if not can_decrease?(what) then
        raise ChargenError.new("Cannot decrease this stat any further!")
      end
      @increases.decrease(what)
      calculate_buypoints()
    end

    def strength
      return @base.strength + @increases.strength
    end

    def dexterity
      return @base.dexterity + @increases.dexterity
    end

    def constitution
      return @base.constitution + @increases.constitution
    end

    def intelligence
      return @base.intelligence + @increases.intelligence
    end

    def wisdom
      return @base.wisdom + @increases.wisdom
    end

    def charisma
      return @base.charisma + @increases.charisma
    end
    
    def get ( what )
      return @base.by_name(what) + @increases.by_name(what)
    end
    
    def get_mod ( what )
      ab = get(what)
      return (ab - 10) / 2
    end
    
    def clear
      @increases = Attributes.new(0, 0, 0, 0, 0, 0)
      calculate_buypoints()
    end
    
    def remaining_buypoints
      return (@maxbuypoints - @buypoints)
    end
    
  end

end
