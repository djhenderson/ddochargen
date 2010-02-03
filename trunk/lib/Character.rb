
require "lib/CharacterAttributes.rb"
require "lib/Alignment.rb"
require "lib/Level.rb"

module DDOChargen

  class Character 

    attr_accessor :attributes, :first_name, :last_name, :levels, :database, :alignment, :gender

    def initialize ( database )
      @database = database

      # LG is the default alignment
      @alignment = Alignment::LAWFUL_GOOD
      @attributes = CharacterAttributes.new()
      
      # Add the levels.
      @levels = Array.new
      20.times { |level|
        @levels.push Level.new(self, level+1)
      }
      
      @race = nil
    end

    # **TODO** This function is a stub
    def has_feat ( f )
      return false
    end
    
    def race
      return @race
    end

    # Special setter for race.
    def race=(r)
      if not r.allows_32pt
        # It's an 28 point build.
        @attributes.maxbuypoints = 28
      end
      # Copy over the base attributes from the race.
      @attributes.base = r.base_attributes 
      # Clear out level 1 feats gained, and copy the new ones over.
      if not @race == nil
        @race.feats_gained.each { |f|
          @levels[0].feats_gained.delete f
        }
      end
      @levels[0].feats_gained.concat r.feats_gained
      
      # Special setter.
      @race = r
    end

    def class_level(c, level = 20)
      classlevel = 0
      level.times { |x|
        if @levels[x].character_class == c then
          classlevel = classlevel + 1
        end
      }
      return classlevel
    end

    def can_level_in_class(c, level = 20)
      # Check alignment restrictions.
      if not c.dependencies.meets(@levels[0])
        return false
      end
      # Create an array of the classes this character
      # already has leveled in.
      mc = Array.new
      level.times { |x|
        lc = @levels[x].character_class
        if mc.size <= 3 and not mc.include?(lc)
          mc << lc
        end
      }
      # If it's smaller than four or he already leveled in that class
      # it's alright that he levels further in it.
      return (not (mc.size >= 3 and not mc.include?(c)))
    end

    def to_s
      return "Character [Name = #{first_name} #{last_name}, Attributes = #{attributes}, Levels = [ #{levels}] ]"
    end

  end

end
