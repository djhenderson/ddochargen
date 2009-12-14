
require "lib/Feat.rb"
require "lib/Dependency.rb"

module DDOChargen

  class FeatDependency < Dependency
    attr_accessor :feat

    def initialize(feat = nil)
      @feat = feat
    end

    def meets ( level )
      return level.character.has_feat(@feat)
    end

  end

end
