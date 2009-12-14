
require "lib/CharacterAttributes.rb"
require "lib/Level.rb"

module DDOChargen

  class Character 

    attr_accessor :attributes, :first_name, :last_name, :race, :levels, :database

    def initialize ( database )
      @database = database

      @attributes = CharacterAttributes.new()
      
      # Add the levels.
      @levels = Array.new
      20.times { |level|
        @levels.push Level.new(self, level+1)
      }
    end

    # **TODO** This function is a stub
    def has_feat ( f )
      return false
    end

    def to_s
      return "Character [Name = #{first_name} #{last_name}, Attributes = #{attributes}, Levels = [ #{levels}] ]"
    end

  end

end
