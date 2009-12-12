
class Skill
  attr_accessor :name, :related_attribute, :description, :usable_untrained

  def initialize(name = "", relatedattr = "", usable = true)
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

  def to_s
    return "Name = #{name}, Related Attribute = #{related_attribute}, Description = #{description}, Usable Untrained = #{usable_untrained}"
  end
end
