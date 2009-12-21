
require "lib/Character.rb"
require "lib/Database.rb"
require "ui/MainWindow.rb"

require 'gtk2'

# Load data.
db = DDOChargen::Database.new()
db.backend.source = "./data/"
db.load()

# Every character is assigned his own database. This pretty much makes
# the character a god object. But who cares? Seriously, the character is
# *the* central object of a character generator!
char = DDOChargen::Character.new(db)

# Create a Main Window
@mw = UI::MainWindow.new(char)
Gtk.main


