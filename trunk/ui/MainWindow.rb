
require "lib/Character.rb"

require 'gtk2'
require 'libglade2'

module UI

  class MainWindow
  
    attr_reader :ui, :mw, :race, :gender, :buildpoints, :alignment
  
    def initialize ( character )
      @character = character
    
      @ui = Gtk::Builder.new
      @ui.connect_signals { |handler| self.send(handler) }
      @ui.add("ui/mainwindow.xml")
      
      @mw = @ui.get_object("mainwindow") 
      @mw.signal_connect('destroy') { on_quit }
            
      # Fill lists.
      @db = @character.database
      
      # I have to admit, this is the most circumstanced way I have
      # ever seen. I also have to admit, that the Gtk Table is powerful
      # and that it's something I'll use for the UI here.
      table = @ui.get_object("general_table")
      @gender = Gtk::ComboBox.new(true)
      @gender.signal_connect("changed") { on_gender_changed }
      @gender.show
      table.attach(@gender, 1, 2, 1, 2)
            
      @race = Gtk::ComboBox.new(true)
      @race.signal_connect("changed") { on_race_changed }
      @race.show
      table.attach(@race, 1, 2, 2, 3)
      
      @buildpoints = Gtk::ComboBox.new(true)
      @buildpoints.signal_connect("changed") { on_buildpoints_changed }
      @buildpoints.show
      table.attach(@buildpoints, 1, 2, 3, 4)
      
      @alignment = Gtk::ComboBox.new(true)
      @alignment.signal_connect("changed") { on_alignment_changed }
      @alignment.show
      table.attach(@alignment, 1, 2, 4, 5)
      
      # Fill 'em
      @gender.append_text("Female")
      @gender.append_text("Male")
      
      # Races.
      @db.races.each { |race|
        @race.append_text(race.name)
      }
      
      # Alignments
      align = DDOChargen::Alignment.new
      align.to_a.each { |a| 
        @alignment.append_text align.to_str(a)
      }
      
      @bpall = [ 28, 30, 32, 34, 36 ];   
      @bpall.each { |x| 
        @buildpoints.append_text x.to_s
      }
      
      @attr = [ "str", "dex", "con", "int", "wis", "cha" ]
      
      # Add the proper signals to the elements.
      @attr.each { |a|
        @ui.get_object(a).editable = false
        inc = a + "inc" # Attribute incrementers
        dec = a + "dec" # Attribute decrementers
        @ui.get_object(inc).signal_connect("clicked") { increase(a) }
        @ui.get_object(dec).signal_connect("clicked") { decrease(a) } 
      }
      
      update_stats()
            
      @mw.show
    end
  
    def on_quit
      Gtk.main_quit
    end
    
    def on_gender_changed
      @character.gender = @gender.active_text
    end
    
    def on_race_changed
      r = @character.database.find_first(@race.active_text, "Race")
      @character.race = r
      update_stats()
    end
    
    def on_alignment_changed
      align = DDOChargen::Alignment.new
      newa = align.from_str(@alignment.active_text)
      @character.alignment = newa
    end
    
    def on_buildpoints_changed
      bp = @buildpoints.active_text.to_i
      @character.attributes.maxbuypoints = bp
      if @character.attributes.buypoints > bp
        # **TODO** Find a better solution here.
        dlg = Gtk::MessageDialog.new(@mw, Gtk::Dialog::DESTROY_WITH_PARENT,
                                          Gtk::MessageDialog::INFO,
                                          Gtk::MessageDialog::BUTTONS_CLOSE,
                                     "You have spent too many buildpoints. Your increases will be reset.")
                                     
        dlg.run
        dlg.destroy
        
        @character.attributes.clear
      end
      update_stats
    end
    
    def update_stat(what)
      @ui.get_object(what).text = @character.attributes.get(what).to_s
      mod = @character.attributes.get_mod(what)
      if mod >= 0 then
        mod = "+" + mod.to_s
      end
      @ui.get_object(what+"mod").text = mod.to_s
      @ui.get_object("remaining").text = @character.attributes.remaining_buypoints.to_s 
    end
    
    def update_stats
      @attr.each { |x|
        update_stat(x)
      }
    end
    
    def increase ( what )
      if @character.attributes.can_increase?(what)
        @character.attributes.increase(what)
        update_stat(what)
      end
    end
    
    def decrease ( what )
      if @character.attributes.can_decrease?(what)
        @character.attributes.decrease(what)
        update_stat(what)
      end
    end
  
  end

end

