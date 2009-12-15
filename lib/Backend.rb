
# Base class for all data backends.

module DDOChargen

  class Backend
    attr_accessor :source 

    def initialize
      @source = ""
    end
  end

end
