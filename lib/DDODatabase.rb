
require "lib/Skill.rb"
require "lib/RonHilerBackend.rb"

class DDODatabase

  attr_accessor :skills, :races, :backend

  def initialize ( be = RonHilerBackend.new() ) 
    @backend = be
  end

  def load
    @skills = backend.load_skills()
    @races = backend.load_races()
  end

end
