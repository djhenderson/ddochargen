
require "lib/Dependencies.rb"

module DDOChargen

  class Class

    attr_accessor :dependencies, :name, :hitdice, :saves, :feats_gained, :bab, :skillpoints, :bonus_feats_at

    # Initialize some things.
    def initialize
      @dependencies = Dependencies.new
      @hitdice = 6

      @bonus_feats_at = Array.new(20, 0)

      # Initialize saves.
      @saves = Hash.new
      @saves["will"] = Array.new(20, 0)
      @saves["reflex"] = Array.new(20, 0)
      @saves["fortitude"] = Array.new(20, 0)

      @feats_gained = Array.new
      20.times {
        @feats_gained.push Array.new
      }
      @bab = 1
    end

    def fortitude_save_at (level)
      return @saves["fortitude"][level-1].to_i
    end

    def reflex_save_at (level)
      return @saves["reflex"][level-1].to_i
    end

    def will_save_at (level)
      return @saves["will"][level-1].to_i
    end

    def ==(c)
      return (c.to_s.downcase == name.downcase)
    end

    def to_s
      return @name
    end

  end

end
