
# This class represents one given level of the character.

require "lib/Attribute.rb"
require "lib/Character.rb"

module DDOChargen

  class Level
    attr_reader :character, :level, :skill_increases, :feats_gained, :increase_in, :character_class

    def initialize ( character, lvl )
      @character = character
      @level = lvl
      # Per default a skill increase is zero, as in: we didn't
      # put any skillpoints in it.
      @skill_increases = Hash.new(0)
      # Array containing the the feats gained (per race or class) on this level
      @feats_gained = Array.new
      # Defaults go into strength
      @increase_in = Attribute.new("str")
    end

    def can_increase_attribute?
      return level.modulo(4) == 0
    end

    def character_class=(c)
      cc = @character.database.find_first c.to_s, "Class"
      if not cc.nil?
        @character_class = cc
      end
    end

    # For backwards compability
    alias :can_increase_ability? :can_increase_attribute?

    def increase_attribute(ability)
      if can_increase_ability?
        @increase_in = Attribute.new(ability)
      end
    end

    def can_select_feat?
      return (level.modulo(3) == 0 or level == 1)
    end

    def skill_rank ( skill )
      rank = 0
      (@level).times { |i|
        l = @character.levels[i]
        rank += l.skill_increases["#{skill.to_s}"]
      }
      return rank
    end

    def attribute (ability)
      a = Attribute.new(ability)
      # Get base
      base = @character.attributes.get(ability.to_s)
      # Add level increases and tomes on top of that!
      @level.times { |x|
        l = @character.levels[x]
        # **TODO** Get tome increases here too.
        if l.can_increase_ability? and a == l.increase_in.to_s
          base = base + 1
        end
      }
      return base
    end

    def bab
      bab = 0
      @level.times { |x|
        lc = @character.levels[x].character_class
        if not lc.nil?
          bab += lc.bab
        end
      }
      return bab
    end

    def to_s
      return "Level [Level = #{level}]"
    end
  end

end
