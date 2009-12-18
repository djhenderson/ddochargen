
require "lib/CharacterAttributes.rb"
require "lib/Alignment.rb"
require "lib/Level.rb"

module DDOChargen

  class Character 

    attr_accessor :attributes, :first_name, :last_name, :race, :levels, :database, :alignment

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
