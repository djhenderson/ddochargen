
module DDOChargen

  class Attribute

    attr_accessor :attribute

    def initialize (a)
      @attribute = a.to_s.downcase
    end

    def valid?
      list = [ "strength", "str",
               "dexterity", "dex",
               "constitution", "con",
               "intelligence", "int",
               "wisdom", "wis",
               "charisma", "cha" ]
      return (not list.index(@attribute).nil?)
    end

    def ==(a)
      ab = Attribute.new(a)
      if ab.valid? and valid?
        if ab.attribute[0,3] == @attribute[0,3]
          return true
        end
      end
      return false
    end

    def longname
      if not valid?
        return nil # Not valid
      end
      if @attribute.length > 3
        return @attribute
      end
      list = [ "strength", "dexterity", "constitution", "intelligence", "wisdom", "charisma" ]
      list.each { |x|
        if x[0,3] == @attribute
          return x
        end
      }
      return nil # Some other error
    end

    def shortname
      if not valid?
        return nil
      end
      if @attribute.length == 3
        return @attribute
      else
        return @attribute[0,3]
      end
    end

    def to_s
      return @attribute
    end

  end

end
