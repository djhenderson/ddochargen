
class Attributes
  
  attr_accessor :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma

  def initialize(str = 8, dex = 8, con = 8, int = 8, wis = 8, cha = 8 ) 
    @strength = str
    @dexterity = dex
    @constitution = con
    @intelligence = int
    @wisdom = wis
    @charisma = cha
  end

  def names
    return ["str", "dex", "con", "int", "wis", "cha"]
  end

  def by_name ( name )
    if name == "strength" or name == "str"
      return @strength
    elsif name == "dexterity" or name == "dex"
      return @dexterity
    elsif name == "constitution" or name == "con"
      return @constitution
    elsif name == "intelligence" or name == "int"
      return @intelligence
    elsif name == "wisdom" or name == "wis"
      return @wisdom
    elsif name == "charisma" or name == "cha"
      return @charisma
    else
      raise ArgumentError.new("No such attribute #{name}.")
    end
  end

  def set ( name, value )
    if value < 0 
      raise ArgumentError.new("Attribute must not be less than zero.")
    end
    if name == "strength" or name == "str"
      @strength = value
    elsif name == "dexterity" or name == "dex"
      @dexterity = value
    elsif name == "constitution" or name == "con"
      @constitution = value
    elsif name == "intelligence" or name == "int"
      @intelligence = value
    elsif name == "wisdom" or name == "wis"
      @wisdom = value
    elsif name == "charisma" or name == "cha"
      @charisma = value
    else
      raise ArgumentError.new("No such attribute: #{name}")
    end
  end

  def increase(what)
    value = by_name(what)
    set(what, value+1)
  end

  def decrease(what)
    value = by_name(what)
    set(what, value-1)
  end

  def to_s
    return "Strength = #{strength}, Dexterity = #{dexterity}, Constitution = #{constitution}, " +
      "Intelligence = #{intelligence}, Wisdom = #{wisdom}, Charisma = #{charisma}"
  end

end
