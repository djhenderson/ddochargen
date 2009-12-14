
require "lib/Backend.rb"
require "lib/Skill.rb"
require "lib/Race.rb"
require "lib/Feat.rb"

require "lib/SkillDependency.rb"
require "lib/FeatDependency.rb"

module DDOChargen

  class RonHilerBackend < Backend

    def initialize
    end

    def split_line ( line )
      if line =~ /([^:]+): ([^;]+)/
        return Array.new([ $1, $2 ]);
      end
    end

    def load_skills
      skillfile = @source + "/SkillFile.txt"
      skill = Skill.new
      skills = Array.new

      File.open(skillfile, "r").each do |line|
        line = line.chomp
        if line =~ /SKILLNAME: ([^;]+);/
          skill = Skill.new()
          skill.name = $1
          # Per default our skills are usable untrained.
          # this saved me some typing when fixing Ron Hilers
          # data files.
          skill.usable_untrained = true
        elsif line =~ /DESCRIPTION: ([^;]+);/
          skill.description = $1
        elsif line =~ /KEYABILITY: (\w+)/
          skill.related_attribute = $1.downcase.strip
        elsif line =~ /USABLEUNTRAINED: (\w+)/
          skill.usable_untrained = ($1.downcase == "yes")
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

    def parse_requirements ( deparray, value )
      value.split(",").each { |req|
        req = req.strip
        if req =~ /(\w+)\s(.+)/
          what = $1.downcase
          text = $2
          if what == "feat" 
            # A feat dependency, text is the feat.
            deparray.push FeatDependency.new(text)
          elsif what == "skill"
            # A skill dependency, very rare that is why
            # RonHiler has it wrong. In RHs editor a bard A gets
            # the song on the same level as a bard B who puts an increase
            # in perform every level regardless if he (bard A) puts points
            # into perform or not. This is a bug!
            sdep = text.split(":")
            deparray.push SkillDependency.new(sdep[0].strip, sdep[1].strip)
          end
        end
      }
    end

    def load_feats
      featsfile = @source + "/FeatsFile.txt"
      feat = Feat.new

      File.open(featsfile, "r").each { |line|
        line = line.chomp.strip

        if line.empty?
        else
          nvp = split_line(line)
          key = nvp[0].downcase
          value = nvp[1]

          if key == "featname"
            feat.name = value
          elsif key == "featdescription"
            feat.description = value
          elsif key == "needsall"
            
          end
        end
      }
    end
    
  end

end
