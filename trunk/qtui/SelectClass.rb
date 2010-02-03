
require 'Qt4'
require 'qtui/SelectClass.ui.rb'

module QtUI

  class SelectClass

    attr_reader :selected_class

    def initialize(char, lvl)
      @character = char
      @level = lvl

      @ui = Ui::SelectClass.new
      @dlg = Qt::Dialog.new
      @ui.setupUi(@dlg)

      @ui.classes.connect(SIGNAL("itemClicked(QListWidgetItem*)")) { |item| on_class_clicked(item) }

      # Fill list with all the classes.
      @character.database.classes.each { |x| 
        item = Qt::ListWidgetItem.new
        item.text = x.name
        # See if the class is selectable by this character.
        if not @character.can_level_in_class(x, lvl)
          item.flags = 0
        else
          item.flags = Qt::ItemIsSelectable | Qt::ItemIsEnabled
        end

        @ui.classes.addItem(item)
      }
    end

    def on_class_clicked(item)
      @selected_class = @character.database.find_first item.text, "Class"
    end

    def exec
      return @dlg.exec
    end

  end

end
