
require "lib/Backend.rb"
require "lib/Skill.rb"
require "lib/Race.rb"

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

  def load_races
    racefile = @source + "/RaceFile.txt"
    races = Array.new()
    race = Race.new()

    File.open(racefile).each() { |line| 
      line = line.chomp()
      if line =~ /RACENAME: ([^;]+)/
        race = Race.new($1)
      elsif line =~ /BASESTATS: ([^;]+)/
        stats = $1.split(",")
        race.base_attributes = Attributes.new(stats[0].strip, stats[1].strip, stats[2].strip,
                                              stats[3].strip, stats[4].strip, stats[5].strip)
      elsif line =~ /FEATURES: ([^;]+)/
        $1.split(",").each() { |feature| 
          feature = feature.chomp().downcase().strip()
          if feature == "extraskillpoint"
            race.extra_skillpoint = true
          elsif feature == "extrafeat"
            race.extra_feat = true
          elsif feature == "32pt"
            race.allows_32pt = true
          end
        }
      elsif line.empty?
        races.push(race)
      end
    }
    races.push(race)
    return races
  end
  
end
