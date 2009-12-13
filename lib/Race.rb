
require "lib/Attributes.rb"

class Race
  attr_accessor :name, :description, :allows_32pt, :extra_skillpoint, :extra_feat, :feats_gained, :base_attributes

  def initialize ( n = "" )
    @name = n
    @allows_32pt = false
    @extra_skillpoint = false
    @extra_feat = false
    @base_attributes = Attributes.new()
  end
  
  def to_s
    return "Name = #{name}, Allows 32pt = #{allows_32pt}, Extra Skillpoint = #{extra_skillpoint}, Extra Feat = #{extra_feat}, Feats Gained = #{feats_gained}, Base Attributes = #{base_attributes}"
  end

end
