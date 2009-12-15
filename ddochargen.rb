
require "lib/Character.rb"
require "lib/Database.rb"

# Load data.
db = DDOChargen::Database.new()
db.backend.source = "./data/"
db.load()

# Every character is assigned his own database. This pretty much makes
# the character a god object. But who cares? Seriously, the character is
# *the* central object of a character generator!
char = DDOChargen::Character.new(db)
char.first_name = "Lelah"
char.last_name = ""
attr = char.attributes

attr.maxbuypoints = 32

8.times { attr.increase("str") }
puts "Str = #{attr.strength} Buypoints = #{attr.buypoints}"
8.times { attr.increase("dex") }
puts "Dex = #{attr.dexterity} Buypoints = #{attr.buypoints}"
4.times { attr.increase("con") }
puts "Con = #{attr.constitution} Buypoints = #{attr.buypoints}"
puts "Int = #{attr.intelligence} Buypoints = #{attr.buypoints}"
8.times { attr.increase("wis") }
puts "Wis = #{attr.wisdom} Buypoints = #{attr.buypoints}"
puts "Cha = #{attr.charisma} Buypoints = #{attr.buypoints}"

feat = db.find_first "Mithral Body", "feat"
if not feat == nil
  puts feat
  puts feat.dependencies.describe
end
