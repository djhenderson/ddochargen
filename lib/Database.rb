
require "lib/Skill.rb"
require "lib/RonHilerBackend.rb"

module DDOChargen

  class Database

    attr_accessor :skills, :races, :feats, :backend

    def initialize ( be = RonHilerBackend.new() ) 
      @backend = be
    end

    def load ( source = nil )
      if not source == nil
        @backend.source = source
      end

      @skills = backend.load_skills
      @feats = backend.load_feats
      @races = backend.load_races
    end

    def find_in ( what, where )
      idx = where.index(what)
      return where[idx] unless idx == nil
      return nil
    end

    def find_first ( what, where = nil )
      obj = find_in(what, @skills)
      return obj if not obj == nil and (where == nil or where.downcase == "skill")
      obj = find_in(what, @feats)
      return obj if not obj == nil and (where == nil or where.downcase == "feat")
      obj = find_in(what, @races)
      return obj if not obj == nil and (where == nil or where.downcase == "race")
      return nil
    end

  end

end
