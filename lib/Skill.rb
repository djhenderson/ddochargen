
class Skill
  attr_reader :name, :related_attribute

  def initialize(name, relatedattr, usable = true)
    @name = name
    @related_attribute = relatedattr
    @usable_untrained = usable
  end

  def usable_untrained?
    return @usable_untrained
  end

  def ==(skill)
    return (skill.name == @name)
  end
end
