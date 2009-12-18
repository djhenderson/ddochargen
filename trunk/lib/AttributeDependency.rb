
require "lib/Dependency.rb"
require "lib/Attributes.rb"

module DDOChargen

  class AttributeDependency < Dependency
    attr_accessor :attribute, :rank

    def initialize ( attr = nil, r = 0 )
      @attribute = attr
      @rank = r
    end

    def meets ( level )
      return (level.base_attribute(@attribute) >= @rank)
    end

    def describe
      return "Invalid AttributeDependency" unless @attribute == nil
      return "Attribute #{attribute} Base (with tomes) #{rank}"
    end

  end

end
