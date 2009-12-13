
require "lib/Skill.rb"
require "lib/RonHilerBackend.rb"

module DDOChargen

  class Database

    attr_accessor :skills, :races, :backend

    def initialize ( be = RonHilerBackend.new() ) 
      @backend = be
    end

    def load
      @skills = backend.load_skills()
      @races = backend.load_races()
    end

  end

end
