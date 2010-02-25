
require 'Qt4'

require "qtui/MainWindow.ui.rb"
require "qtui/SelectClass.rb"

module QtUI

  class ItemAction
    ABILITY = 1
  end

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

      level.connect(SIGNAL("itemClicked(QTableWidgetItem*)")) { |x| on_level_table_clicked(x) }
      level.horizontalHeader.connect(SIGNAL("sectionClicked(int)")) { |x| on_level_table_column_clicked(x) }
      
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
        btn.flat = true
        btn.connect(SIGNAL(:clicked)) { on_level_button((x+1)) }
        level.setCellWidget(x, 0, btn)

        # Fill up with fighter.
        @character.levels[x].character_class = "Fighter"

        btn = Qt::PushButton.new
        btn.accessibleName = "class" + (x+1).to_s
        btn.text = @character.levels[x].character_class.to_s
        btn.flat = true
        btn.connect(SIGNAL(:clicked)) { on_class_button((x+1)) }
        level.setCellWidget(x, 1, btn);
        
        on_class_changed(x+1, @character.levels[x].character_class)
      }
    end
    
    def update_level_table
      20.times { |x|
        update_level_table_abilities(x)
        update_level_table_bab(x)
        update_level_table_feats_gained(x)
        update_level_table_saves(x)
      }
    end

    def update_level_table_saves(x)
      lvl = @character.levels[x]

      itm = @ui.level.item(x, 9)
      if itm.nil?
        itm = Qt::TableWidgetItem.new
        @ui.level.setItem(x, 9, itm)
      end
      itm.text = lvl.fortitude_save.to_s

      itm = @ui.level.item(x, 10)
      if itm.nil?
        itm = Qt::TableWidgetItem.new
        @ui.level.setItem(x, 10, itm)
      end
      itm.text = lvl.reflex_save.to_s

      itm = @ui.level.item(x, 11)
      if itm.nil?
        itm = Qt::TableWidgetItem.new
        @ui.level.setItem(x, 11, itm)
      end
      itm.text = lvl.will_save.to_s
    end

    def update_level_table_bab(x)
      bab = @character.levels[x].bab
      
      itm = @ui.level.item(x, 8)
      if itm.nil?
        itm = Qt::TableWidgetItem.new
        @ui.level.setItem(x, 8, itm)
      end
      itm.text = bab.floor.to_s
    end
    
    def update_level_table_feats_gained(x)
      c = @character.levels[x].character_class
      if c.nil?
        return
      end
      # **TODO** Pack this logic into the character class instead.
      cl = @character.class_level(c, x+1)
      fg = c.feats_gained[cl-1]
      if x == 0 and not @race.nil?
        # If this is the first level, then they are usually
        # some feats the race gains aswell.
        fg = fg | @character.race.feats_gained
      end
      str = fg.collect { |f| f.to_s }.join(", ")
      itm = @ui.level.item(x, 13)
      if itm.nil?
        itm = Qt::TableWidgetItem.new
        @ui.level.setItem(x, 13, itm)
      end
      itm.text = str
    end

    # Small function to update only a portion of the level table.
    def update_level_table_abilities(l)
      level = @ui.level
      attr = [ "str", "dex", "con", "int", "wis", "cha" ]
            
      attr_idx = 2 # Starting position for the attribute columns
      attr.each { |a|
        item = level.item(l, attr_idx)
        if item.nil?
          item = Qt::TableWidgetItem.new
          # Optimisation: Don't construct a new one, if one's already there.
          item = Qt::TableWidgetItem.new
          item.textAlignment = Qt::AlignCenter
          item.flags = Qt::ItemIsEnabled
          # Insert.
          level.setItem(l, attr_idx, item)
        end
        if @character.levels[l].can_increase_ability?
          # Tag this item so that it's clear it's an ability increase thingee.
          item.setData(Qt::UserRole + 0, Qt::Variant.new(QtUI::ItemAction::ABILITY))
          item.setData(Qt::UserRole + 1, Qt::Variant.new(l)); # Column
          item.setData(Qt::UserRole + 2, Qt::Variant.new(attr_idx)) # Set level
          item.setData(Qt::UserRole + 3, Qt::Variant.new(a)) # Set ability
          # Mark all non-bold except those we have an increase in.
          # **TODO** Find something better than making the text bold.
          fnt = item.font
          fnt.bold = (@character.levels[l].increase_in == a)
          item.font = fnt
        end
        item.text = @character.levels[l].attribute(a).to_s
        attr_idx = attr_idx + 1
      }
    end
    
    def on_level_button (level)
      puts "Level button pressed: " + level.to_s + "\n"
    end

    def on_class_button (level)
      @sc = QtUI::SelectClass.new(@character, level)
      if @sc.exec != 0
        c = @sc.selected_class
        if not c.nil?
          @character.levels[level-1].character_class = c
          on_class_changed(level, c)
        end
      end
    end

    def on_class_changed(level, c)
      btn = @ui.level.cellWidget(level-1, 1)
      btn.text = c.name

      20.times { |x|
        # Update feats gained
        update_level_table_feats_gained(x)
        # Update saves
        update_level_table_saves(x)
        # Update BAB
        update_level_table_bab(x)
      }
    end

    def on_level_table_column_clicked(idx)
      attr = [ "str", "dex", "con", "int", "wis", "cha" ]
      if idx >= 2 and idx <= 7
        idx = idx - 2 # make and index out of it.
        @character.levels.each { |l|
          if l.can_increase_attribute?
            l.increase_attribute(attr[idx])
          end
        }
        20.times { |x| update_level_table_abilities(x) }
      end
    end

    def on_level_table_clicked (item)
      action = item.data(Qt::UserRole + 0).toInt

      puts "Item clicked: " + item.to_s + ". Action: " + action.to_s

      if action == ItemAction::ABILITY
        on_level_increase_clicked(item)
      end      
    end

    def on_level_increase_clicked(item)
      lvl = item.data(Qt::UserRole + 1).toInt
      col = item.data(Qt::UserRole + 2).toInt
      ab = item.data(Qt::UserRole + 3).toString

      @character.levels[lvl].increase_attribute(ab)
      update_level_table_abilities()
    end

    def construct_ability_table
      @ui.abilities.showGrid = false
      @ui.abilities.horizontalHeader.hide
      # @ui.abilities.horizontalHeader.defaultSectionSize = 40
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
      # Update first level and the feats gained in that.
      update_level_table_feats_gained(0)
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
