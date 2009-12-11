
require "lib/CharacterAttributes.rb"

class Character 

  attr_accessor :attributes, :first_name, :last_name

  def initialize
    @attributes = CharacterAttributes.new()
  end

end
