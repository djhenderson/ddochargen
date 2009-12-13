
module DDOChargen

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
      return (skill.to_s.downcase == self.to_s.downcase)
    end

    def to_s
      return @name
    end
  end

end
