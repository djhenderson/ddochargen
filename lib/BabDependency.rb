
require "lib/Dependency.rb"

module DDOChargen

  class BabDependency < Dependency
    attr_accessor :bab_required

    def initialize ( bab = 0 )
      @bab_required = bab
    end

    def meets ( level )
      return (level.bab >= @bab_required)
    end

    def describe
      return "BAB #{bab_required}"
    end
  end

end
