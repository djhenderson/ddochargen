
require "lib/Dependency.rb"
require "lib/Race.rb"

module DDOChargen
  
  class RaceDependency < Dependency
    attr_accessor :race, :level, :strict

    def initialize ( race = nil, level = 0, strict = false )
      @race = race
      @level = level
      @strict = strict
    end

    def meets ( level )
      return (level.character.race == @race && level.level >= @level)
    end

    def describe
      return "Invalid race dependency" if @race == nil
      return "Race #{race} Level #{level} Strict #{strict}" 
    end
  end

end
