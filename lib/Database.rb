
require "lib/Skill.rb"
require "lib/RonHilerBackend.rb"

module DDOChargen

  class Database

    attr_accessor :skills, :races, :feats, :backend

    def initialize ( be = RonHilerBackend.new() ) 
      @backend = be
    end

    def load
      @skills = backend.load_skills()
      @races = backend.load_races()
      @feats = backend.load_feats()
    end

  end

end
