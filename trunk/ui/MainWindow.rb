
require "lib/Character.rb"

require 'gtk2'
require 'libglade2'

module UI

  class MainWindow
  
    attr_reader :ui, :mw, :race, :gender, :buildpoints
  
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
      @buildpoints.show
      table.attach(@buildpoints, 1, 2, 3, 4)
      
      # Fill 'em
      @gender.append_text("Female")
      @gender.append_text("Male")
      
      # Races.
      @db.races.each { |race|
        @race.append_text(race.name)
      }
      
      @bpall = [ 28, 30, 32, 34, 36 ];   
      @bpall.each { |x| 
        @buildpoints.append_text x.to_s
      }
            
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
    end
  
  end

end

