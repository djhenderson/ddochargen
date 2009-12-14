
require "lib/Dependency.rb"
require "lib/Attributes.rb"

module DDOChargen

  class AttributeDependency < Dependency
    attr_accessor :attribute, :rank

    def initialize ( attr = "", r = 0 )
      @attribute = attr
      @rank = r
    end

    def meets ( level )
      
    end

  end

end
