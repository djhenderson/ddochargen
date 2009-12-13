
# This class represents one given level of the character.

require "lib/Character.rb"

module DDOChargen

  class Level
    attr_reader :character, :level, :skill_increases

    def initialize ( character, lvl )
      @character = character
      @level = lvl
      # Per default a skill increase is zero, as in: we didn't
      # put any skillpoints in it.
      @skill_increases = Hash.new(0)
    end

    def can_increase_ability?
      return level.modulo(4) == 0
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

    def to_s
      return "Level [Level = #{level}]"
    end
  end

end
