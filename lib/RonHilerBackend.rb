
require "lib/Backend.rb"
require "lib/Skill.rb"

class RonHilerBackend < Backend

  def initialize
  end

  def load_skills
    skillfile = @source + "/SkillFile.txt"
    skill = Skill.new()
    skills = Array.new()

    File.open(skillfile, "r").each do |line|
      line = line.chomp
      if line =~ /SKILLNAME: ([^;]+);/
        skill = Skill.new()
        skill.name = $1
        skill.usable_untrained = false
      elsif line =~ /DESCRIPTION: ([^;]+);/
        skill.description = $1
      elsif line =~ /KEYABILITY: (\w+)/
        skill.related_attribute = $1.downcase
      elsif line =~ /CROSS: /
        skill.usable_untrained = true
      elsif line.empty?
        skills.push(skill)
      end
    end
    skills.push(skill)

    return skills
  end
  
end
