
require "lib/Character.rb"
require "lib/Database.rb"

require "ui/MainWindow.rb"
require "qtui/MainWindow.rb"

require 'gtk2'
require 'Qt4'

# Load data.
db = DDOChargen::Database.new()
db.backend.source = "./data/"
db.load()

# Every character is assigned his own database. This pretty much makes
# the character a god object. But who cares? Seriously, the character is
# *the* central object of a character generator!
char = DDOChargen::Character.new(db)

if ARGV[0] == "--qt" then
  app = Qt::Application.new(ARGV)
  @mw = QtUI::MainWindow.new(char, app)
  app.exec
else
  # Create a Main Window
  @mw = UI::MainWindow.new(char)
  @mw.run
end


