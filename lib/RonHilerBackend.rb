
require "lib/Backend.rb"
require "lib/Skill.rb"
require "lib/Race.rb"
require "lib/Feat.rb"

require "lib/RaceDependency.rb"
require "lib/SkillDependency.rb"
require "lib/FeatDependency.rb"
require "lib/BabDependency.rb"

module DDOChargen

  class RonHilerBackend < Backend

    def initialize
      @automatic_races = Hash.new
      @automatic_classes = Hash.new
    end

    def split_line ( line )
      if line =~ /([^:]+): ([^;]+);/
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

      # Add for each race the list of feats it gains.
      races.each { |race| 
        autofeats = @automatic_races[race.name]
        if not autofeats == nil
          autofeats.each { |feat|
            # The race has gained this feat.
            race.feats_gained.push feat
          }
        end
      }

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
          elsif what == "bab"
            deparray.push BabDependency.new(text)
          end
        end
      }
    end

    def load_feats
      featsfile = @source + "/FeatsFile.txt"
      feat = Feat.new
      feats = Array.new

      races = Array.new
      levels = Array.new
      classes = Array.new
      had_classlist = had_racelist = false
      heading = ""

      File.open(featsfile, "r").each { |line|
        line = line.chomp.strip

        if line.empty?
          feats.push feat
          feat = Feat.new
        else
          nvp = split_line(line)
          if nvp == nil
            raise ChargenError.new("Invalid line in Feats: #{line}")
          end
          key = nvp[0].downcase
          value = nvp[1]

          if key == "parentheading"
            heading = value
          elsif key == "featname"
            if not heading.empty?
              value = heading + ": " + value
            end
            feat.name = value
            heading = ""
          elsif key == "featdescription"
            feat.description = value
          elsif key == "racelist"
            races = value.split(",")
            had_racelist = true
          elsif key == "level"
            levels = value.split(",")
          elsif key == "classlist"
            classes = value.split(",")
            had_classlist = true
          elsif key == "acquire"
            how = value.split(",")
            how.each { |x|
              idx = how.index(x)
              x = x.downcase
              if x == "automatic" or x == "autonoprereq"
                if had_racelist
                  @automatic_races[races[idx]] = Array.new if @automatic_races[races[idx]] == nil
                  @automatic_races[races[idx]].push feat.name
                elsif had_classlist
                  @automatic_classes[classes[idx]] = Hash.new if @automatic_classes[classes[idx]] == nil
                  @automatic_classes[classes[idx]][levels[idx]] = feat.name
                end
              end
            }
            had_racelist = had_classlist = false
          elsif key == "needsall"
            # Special cases up a ahead: Feats only a WF can select
            # on level up.
            if value.downcase == "creation"
              # Add a race dependency here for safety reasons.
              feat.train_able = true
              rd = RaceDependency.new(races[0].strip, levels[0].strip, true)
              feat.dependencies.all_of.push rd
            else
              parse_requirements(feat.dependencies.all_of, value)
            end
          elsif key == "needsone"
            # Parse needs one of requirements.
            parse_requirements(feat.dependencies.one_of, value)
          end
        end
      }

      return feats
    end
    
  end

end
