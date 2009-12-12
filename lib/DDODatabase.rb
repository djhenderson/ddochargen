
require "lib/Skill.rb"
require "lib/RonHilerBackend.rb"

class DDODatabase

  attr_accessor :skills, :backend

  def initialize ( be = RonHilerBackend.new() ) 
    @backend = be
  end

  def load
    @skills = backend.load_skills()
  end

end
