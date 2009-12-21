
require "lib/Backend.rb"
require "lib/Skill.rb"
require "lib/Race.rb"
require "lib/Feat.rb"
require "lib/Class.rb"

require "lib/RaceDependency.rb"
require "lib/SkillDependency.rb"
require "lib/FeatDependency.rb"
require "lib/BabDependency.rb"
require "lib/AlignmentDependency.rb"

module DDOChargen

  class RonHilerBackend < Backend

    def initialize
      @automatic_races = Hash.new
      @automatic_classes = Hash.new
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
          race.base_attributes = Attributes.new(Integer(stats[0].strip), Integer(stats[1].strip), 
                                                Integer(stats[2].strip), Integer(stats[3].strip), 
                                                Integer(stats[4].strip), Integer(stats[5].strip))
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

      races.each { |race|
        race.feats_gained = race.feats_gained.uniq
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
          elsif key == "feattag"
            value.split(",").each { |tag|
              tag = tag.strip.downcase
              if tag == "multiple"
                feat.multiple_times = true
              elsif tag == "monk bonus"
                feat.bonus_feat_for["Monk"] = true
              elsif tag == "fighter bonus"
                feat.bonus_feat_for["Fighter"] = true
              elsif tag == "metamagic"
                # if it's "metamagic" it can be taken as a Wizard bonus feat.
                feat.bonus_feat_for["Wizard"] = true
              elsif tag == "favored enemy"
                feat.bonus_feat_for["Ranger"] = true
                # Auto assign: Exclusive Bonus feat.
                feat.exclusive_bonus = true
              elsif tag == "favored soul bonus" or tag == "divine"
                feat.bonus_feat_for["Favored Soul"] = true
                feat.exclusive_bonus = true
              elsif tag == "rogue bonus"
                feat.bonus_feat_for["Rogue"] = true
                if not feat.name == "Improved Evasion"
                  feat.exclusive_bonus = true
                end
              end
            }
          elsif key == "exclusivebonus"
            feat.exclusive_bonus = (value.strip.downcase == "yes" ? true : false)
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
              x = x.strip.downcase
              if x == "automatic" or x == "autonoprereq"
                # The race and class list are seperate but the acquire line
                # combines those two: first race and then class.
                if had_racelist and idx < races.length
                  arace = races[idx].strip
                  @automatic_races[arace] = Array.new if @automatic_races[arace] == nil
                  @automatic_races[arace].push feat.name
                end
                if had_classlist and idx >= races.length
                  ix = idx - (had_racelist ? races.length : 0)
                  aclass = classes[ix].strip
                  alevel = levels[idx].strip
                  lidx = Integer(alevel) - 1
                  @automatic_classes[aclass] = Array.new if @automatic_classes[aclass] == nil
                  @automatic_classes[aclass][lidx] = Array.new if @automatic_classes[aclass][lidx] == nil
                  @automatic_classes[aclass][lidx].push feat.name 
                end
              end
            }
            had_racelist = had_classlist = false
            # Read up ahead why I delete these arrays here and not
            # after the "needsall" statement used it.
            races = Array.new
            classes = Array.new
          elsif key == "needsall"
            # Special cases up a ahead: Feats only a WF can select
            # on level up. This is a dirty hack to be honest so we can reset
            # the array "races" before this routine. If we delete it above we cannot
            # use this array here, and we cannot delete the array here, because this
            # needsall clause does not always come up...
            if value.downcase == "creation"
              # Add a race dependency here for safety reasons.
              feat.train_able = true
              rd = RaceDependency.new("Warforged", levels[0].strip, true)
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

    def load_classes
      classfile = @source + "/ClassFile.txt"
      cc = Class.new
      classes = Array.new

      File.open(classfile, "r").each { |x|
        x = x.chomp.strip
        if x.empty?
          cc.feats_gained.each_index { |idx|
            cc.feats_gained[idx] = cc.feats_gained[idx].uniq
          }

          classes.push cc
          cc = Class.new
        else
          nvp = split_line(x)
          if nvp == nil
            next
          end
          key = nvp[0].downcase
          value = nvp[1]

          if key == "classname"
            cc.name = value

            afeats = @automatic_classes[cc.name]
            if not afeats == nil
              afeats.each_index { |idx| 
                cc.feats_gained[idx] = afeats[idx] unless afeats[idx] == nil
              }
            end
          elsif key == "bonusfeats"
            value.split(",").each { |lvl|
              il = Integer(lvl.strip) - 1
              cc.bonus_feats_at[il] = 1
            }
          elsif key == "hitdie"
            cc.hitdice = Integer(value)
          elsif key == "bab"
            cc.bab = value.to_f
          elsif key == "skillpoints"
            cc.skillpoints = value.to_i
          elsif key == "fortsave"
            cc.saves["fortitude"] = value.split(",")
          elsif key == "refsave"
            cc.saves["reflex"] = value.split(",")
          elsif key == "willsave"
            cc.saves["will"] = value.split(",")
          elsif key == "alignment"
            value.split(",").each { |a|
              align = Alignment.new.from_str(a)
              cc.dependencies.all_of.push AlignmentDependency.new(align)
            }
          end
          
        end
      }

      return classes
    end
    
  end

end
