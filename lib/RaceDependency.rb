
require "lib/Dependency.rb"
require "lib/Race.rb"

module DDOChargen
  
  class RaceDependency < Dependency
    attr_accessor :race, :level

    def initialize ( race = nil, level = 0 )
      @race = race
      @level = level
    end

    def meets ( level )
      return (level.character.race == @race && level.level >= @level)
    end
  end

end
