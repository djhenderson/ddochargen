
require "lib/Dependencies.rb"

module DDOChargen

  class Feat

    attr_accessor :name, :description, :dependencies, :train_able, :bonus_feat_for, :multiple_times

    def initialize 
      # Create dependencies.
      @dependencies = Dependencies.new
      @train_able = true
      # It isn't a bonus for the given class.
      @bonus_feat_for = Hash.new(false)
      # Barely any feat can be taken multiple times.
      @multiple_times = false
    end

  end

end
