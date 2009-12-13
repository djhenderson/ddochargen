
require "lib/Dependency.rb"
require "lib/Race.rb"

module DDOChargen
  
  class RaceDependency < Dependency
    attr_accessor :race

    def initialize ( race = nil )
      @race = race
    end

    def meets ( level )
      return level.character.race == @race
    end
  end

end
