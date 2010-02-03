
require "lib/Alignment.rb"
require "lib/Dependency.rb"

module DDOChargen
  
  class AlignmentDependency < Dependency
    attr_accessor :alignments
    
    def initialize ( align )
      @alignments = Array.new
      align.each { |x|
        a = Alignment.new.from_str(x)
        @alignments << a
      }
    end

    def meets ( level )
      return (@alignments.include?(level.character.alignment));
    end

    def describe
      str = Alignment.new.to_str(@alignment)
      return "Alignment: #{str}"
    end
  end

end
