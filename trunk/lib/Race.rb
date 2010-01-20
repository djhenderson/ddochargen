
require "lib/Attributes.rb"

module DDOChargen

  class Race
    attr_accessor :name, :description, :allows_32pt, :extra_skillpoint, :extra_feat, :feats_gained, :base_attributes

    def initialize ( n = "" )
      @name = n
      @allows_32pt = false
      @extra_skillpoint = false
      @extra_feat = false
      @base_attributes = Attributes.new()
      @feats_gained = Array.new
    end

    def == ( race )
      return race.to_s.downcase == self.to_s.downcase
    end

    def to_s
      return @name
    end

    def allows_32pt?
      return @allows_32pt
    end

  end

end
