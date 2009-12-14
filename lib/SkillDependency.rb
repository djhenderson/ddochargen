
require "lib/Skill.rb"
require "lib/Dependency.rb"

module DDOChargen

  class SkillDependency < Dependency

    attr_accessor :skill, :required_rank

    def initialize ( skill, required_rank )
      @skill = skill
      @required_rank = required_rank
    end

    def meets ( level )
      return level.skill_rank(skill) >= @required_rank
    end

  end

end
