
require 'Qt4'

require "qtui/MainWindow.ui.rb"

module QtUI

  class MainWindow

    def initialize(c, a)
      @a = a
      @character = c
      
      @wnd = Qt::MainWindow.new
      @ui = Ui::MainWindow.new
      @ui.setupUi(@wnd)

      # Construct our ability table.
      construct_ability_table
      update_ability_table
      
      # Level table
      construct_level_table
      update_level_table

      # Fill certain combo boxes.
      @ui.race.connect(SIGNAL("currentIndexChanged(QString)")) { |x| on_race_changed(x) } 
      @character.database.races.each { |r|
        @ui.race.addItem r.name
      }
 
      # Gender.
      @ui.gender.connect(SIGNAL("currentIndexChanged(QString)")) { |x| on_gender_changed(x) }
      @ui.gender.addItem "Female"
      @ui.gender.addItem "Male"

      # Alignments
      @ui.alignment.connect(SIGNAL("currentIndexChanged(QString)")) { |x| on_alignment_changed(x) }
      align = DDOChargen::Alignment.new
      align.to_a.each { |al|
        @ui.alignment.addItem align.to_str(al)
      }
      # Build points.
      @ui.buildpoints.connect(SIGNAL("currentIndexChanged(QString)")) { |x| on_buildpoints_changed(x) }
      @bpall = [ 28, 32 ]
      @bpall.each { |i| 
        @ui.buildpoints.addItem i.to_s
      }

      @wnd.show
      @a.connect(a, SIGNAL('lastWindowClosed()'), a, SLOT('quit()'))
    end

    def run
      # @a.exec
    end
    
    def construct_level_table
      level = @ui.level
      
      level.showGrid = false
      14.times { |x|
        level.horizontalHeader.resizeSection(x, 45)
      }
      # Class can be wider than the rest.
      level.horizontalHeader.resizeSection(1, 100)
      # As can be feats and feats granted.
      level.horizontalHeader.resizeSection(12, 100)
      level.horizontalHeader.resizeSection(13, 100)
      
      # Hide header
      level.verticalHeader.defaultSectionSize = 24
      level.verticalHeader.hide
      
      headers = [ "#", "Class", "STR", "DEX", "CON", "INT", "WIS", "CHA", "BAB", "Fort", "Reflex", "Will", "Feats", "Feats Gained" ]
      
      headers.each_index { |x|
        # Set Header
        itm = Qt::TableWidgetItem.new
        itm.text = headers[x]
        itm.textAlignment = Qt::AlignCenter
        level.setHorizontalHeaderItem(x, itm)
      }
      
      20.times { |x|      
        btn = Qt::PushButton.new
        btn.accessibleName = "level" + (x+1).to_s
        btn.text = (x+1).to_s
        btn.connect(SIGNAL(:clicked)) { on_level_button((x+1)) }
        level.setCellWidget(x, 0, btn)
      }
    end
    
    def update_level_table
      update_level_table_abilities
    end
    
    # Small function to update only a portion of the level table.
    def update_level_table_abilities
      level = @ui.level
      attr = [ "str", "dex", "con", "int", "wis", "cha" ]
      
      20.times { |l|
        lvl = l + 1
        
        attr_idx = 2 # Starting position for the attribute columns
        attr.each { |a|
          item = level.item(l, attr_idx)
          if item.nil?
            # Optimisation: Don't construct a new one, if one's already there.
            item = Qt::TableWidgetItem.new
            item.textAlignment = Qt::AlignCenter
          end
          if @character.levels[l].can_increase_ability? and a == "str"
            fnt = item.font
            fnt.bold = true
            item.font = fnt
            # **TODO** Do level increase magic here.
          end
          item.text = @character.attributes.get(a).to_s
          level.setItem(l, attr_idx, item)
          attr_idx = attr_idx + 1
        }
      }
    end
    
    def on_level_button (level)
      puts "Level button pressed: " + level.to_s + "\n"
    end

    def construct_ability_table
      @ui.abilities.showGrid = false
      @ui.abilities.horizontalHeader.hide
      #@ui.abilities.horizontalHeader.defaultSectionSize = 40
      @ui.abilities.horizontalHeader.resizeSection(0, 90)
      4.times { |x| 
        @ui.abilities.horizontalHeader.resizeSection(x+1, 40)
      }
      
      @ui.abilities.verticalHeader.defaultSectionSize = 24
      @ui.abilities.verticalHeader.hide

      names = [ "Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma" ]
      names.length.times { |i|
        item = Qt::TableWidgetItem.new
        item.flags = Qt::ItemIsSelectable | Qt::ItemIsEnabled
        item.text = names[i]
        @ui.abilities.setItem(i, 0, item)

        btn = Qt::PushButton.new(@wnd)
        btn.accessibleName = names[i] + "inc"
        btn.connect(SIGNAL(:clicked)) { increase(names[i]) }
        btn.text = "+"
        @ui.abilities.setCellWidget(i, 1, btn)

        btn = Qt::PushButton.new(@wnd)
        btn.accessibleName = names[i] + "dec"
        btn.connect(SIGNAL(:clicked)) { decrease(names[i]) }
        btn.text = "-"
        @ui.abilities.setCellWidget(i, 3, btn)
      }
    end

    def update_ability_table
      if @character.attributes.buypoints > @character.attributes.maxbuypoints
        msg = "You have spent too many attribute points, your abilities will be reset."
        Qt::MessageBox.information(@wnd, "Too many points spent.", msg)
        @character.attributes.clear
      end

      ab = [ "str", "dex", "con", "int", "wis", "cha" ]
      ab.each_index { |i|
        item = @ui.abilities.item(i, 2)
        if item.nil?
          item = Qt::TableWidgetItem.new
          item.flags = Qt::ItemIsSelectable | Qt::ItemIsEnabled
          item.textAlignment = Qt::AlignCenter
          @ui.abilities.setItem(i, 2, item)
        end
        item.text = @character.attributes.get(ab[i]).to_s

        item = @ui.abilities.item(i, 4)
        if item.nil?
          item = Qt::TableWidgetItem.new
          item.flags = Qt::ItemIsSelectable | Qt::ItemIsEnabled
          item.textAlignment = Qt::AlignCenter
          @ui.abilities.setItem(i, 4, item)
        end
        mod = @character.attributes.get_mod(ab[i])
        if mod > 0
          mod = "+" + mod.to_s
        else
          mod = mod.to_s
        end
        item.text = mod
      }
      # Update how many buildpoints we got left.
      @ui.gb.title = "Abilities - " + @character.attributes.remaining_buypoints.to_s + " left."
    end

    def increase ( what )
      if @character.attributes.can_increase?(what)
        @character.attributes.increase(what)
        update_ability_table
        update_level_table_abilities
      end
    end

    def decrease ( what )
      if @character.attributes.can_decrease?(what)
        @character.attributes.decrease(what)
        update_ability_table
        update_level_table_abilities
      end
    end

    def on_race_changed ( item )
      r = @character.database.find_first(item, "Race")
      @character.race = r
      @ui.buildpoints.enabled = r.allows_32pt?
      if not r.allows_32pt?
        # Reset to 28pts
        @ui.buildpoints.currentIndex = 0
      end
      update_ability_table
    end

    def on_alignment_changed ( item )
      align = DDOChargen::Alignment.new
      newa = align.from_str(item)
      @character.alignment = newa
    end

    def on_gender_changed ( item )
      @character.gender = item
    end

    def on_buildpoints_changed ( item )
      @character.attributes.maxbuypoints = item.to_i
      update_ability_table
    end

  end
end
