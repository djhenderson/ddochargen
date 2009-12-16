
require "lib/Alignment.rb"
require "lib/Dependency.rb"

module DDOChargen
  
  class AlignmentDependency < Dependency
    attr_accessor :alignment
    
    def initialize ( align = Alignment::LAWFUL_GOOD )
      @alignment = align
    end

    def meets ( level )
      return (level.character.alignment == @alignment)
    end

    def describe
      str = Alignment.new.to_str(@alignment)
      return "Alignment: #{str}"
    end
  end

end
