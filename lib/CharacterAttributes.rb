
require "lib/Attributes.rb"
require "lib/ChargenError.rb"

class CharacterAttributes

  attr_accessor :base, :maxbuypoints
  attr_reader :increases, :buypoints

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
      if value > 0
        value.times { |point| 
          mod = ((base + point + 1) - 10) / 2
          # If its less than zero (i.e. -2) then the cost is 1.
          if mod < 0
            mod = 1
          end
          @buypoints += mod
        }
      end
    }
  end

  def can_increase? ( what ) 
    wouldbe = @base.by_name(what) + @increases.by_name(what)
    if wouldbe > @base.by_name(what)+10
      return false
    end
    calculate_buypoints()
    return (@buypoints < @maxbuypoints)
  end

  def increase ( what )
    if not can_increase?(what) then
      raise ChargenError.new("Cannot increase this stat any further!")
    end
    @increases.increase(what)
    calculate_buypoints()
  end

  def decrease ( what ) 
    if not can_increase?(what) then
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
  
end
