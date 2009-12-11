
require "lib/CharacterAttributes.rb"

attr = CharacterAttributes.new()

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
