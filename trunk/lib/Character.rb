
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

    def to_s
      return "Character [Name = #{first_name} #{last_name}, Attributes = #{attributes}, Levels = [ #{levels}] ]"
    end

  end

end
