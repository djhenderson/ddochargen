=begin
** Form generated from reading ui file 'MainWindow.ui'
**
** Created: Mon Jan 25 09:01:59 2010
**      by: Qt User Interface Compiler version 4.5.3
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_MainWindow
    attr_reader :centralwidget
    attr_reader :gridLayout
    attr_reader :groupBox
    attr_reader :gridLayout1
    attr_reader :label
    attr_reader :name
    attr_reader :label_2
    attr_reader :race
    attr_reader :label_3
    attr_reader :gender
    attr_reader :label_4
    attr_reader :alignment
    attr_reader :label_5
    attr_reader :buildpoints
    attr_reader :gb
    attr_reader :gridLayout2
    attr_reader :abilities
    attr_reader :spacerItem
    attr_reader :spacerItem1
    attr_reader :tabs
    attr_reader :tab
    attr_reader :gridLayout3
    attr_reader :level
    attr_reader :tab_2
    attr_reader :menubar
    attr_reader :statusbar

    def setupUi(mainWindow)
    if mainWindow.objectName.nil?
        mainWindow.objectName = "mainWindow"
    end
    mainWindow.resize(800, 600)
    @centralwidget = Qt::Widget.new(mainWindow)
    @centralwidget.objectName = "centralwidget"
    @gridLayout = Qt::GridLayout.new(@centralwidget)
    @gridLayout.objectName = "gridLayout"
    @groupBox = Qt::GroupBox.new(@centralwidget)
    @groupBox.objectName = "groupBox"
    @groupBox.minimumSize = Qt::Size.new(261, 201)
    @groupBox.maximumSize = Qt::Size.new(261, 201)
    @gridLayout1 = Qt::GridLayout.new(@groupBox)
    @gridLayout1.objectName = "gridLayout1"
    @label = Qt::Label.new(@groupBox)
    @label.objectName = "label"

    @gridLayout1.addWidget(@label, 0, 0, 1, 1)

    @name = Qt::LineEdit.new(@groupBox)
    @name.objectName = "name"

    @gridLayout1.addWidget(@name, 0, 1, 1, 1)

    @label_2 = Qt::Label.new(@groupBox)
    @label_2.objectName = "label_2"

    @gridLayout1.addWidget(@label_2, 1, 0, 1, 1)

    @race = Qt::ComboBox.new(@groupBox)
    @race.objectName = "race"

    @gridLayout1.addWidget(@race, 1, 1, 1, 1)

    @label_3 = Qt::Label.new(@groupBox)
    @label_3.objectName = "label_3"

    @gridLayout1.addWidget(@label_3, 2, 0, 1, 1)

    @gender = Qt::ComboBox.new(@groupBox)
    @gender.objectName = "gender"

    @gridLayout1.addWidget(@gender, 2, 1, 1, 1)

    @label_4 = Qt::Label.new(@groupBox)
    @label_4.objectName = "label_4"

    @gridLayout1.addWidget(@label_4, 3, 0, 1, 1)

    @alignment = Qt::ComboBox.new(@groupBox)
    @alignment.objectName = "alignment"

    @gridLayout1.addWidget(@alignment, 3, 1, 1, 1)

    @label_5 = Qt::Label.new(@groupBox)
    @label_5.objectName = "label_5"

    @gridLayout1.addWidget(@label_5, 4, 0, 1, 1)

    @buildpoints = Qt::ComboBox.new(@groupBox)
    @buildpoints.objectName = "buildpoints"

    @gridLayout1.addWidget(@buildpoints, 4, 1, 1, 1)


    @gridLayout.addWidget(@groupBox, 0, 1, 2, 1)

    @gb = Qt::GroupBox.new(@centralwidget)
    @gb.objectName = "gb"
    @gb.minimumSize = Qt::Size.new(281, 201)
    @gb.maximumSize = Qt::Size.new(281, 201)
    @gridLayout2 = Qt::GridLayout.new(@gb)
    @gridLayout2.objectName = "gridLayout2"
    @abilities = Qt::TableWidget.new(@gb)
    @abilities.objectName = "abilities"
    @abilities.cornerButtonEnabled = false
    @abilities.rowCount = 6
    @abilities.columnCount = 5

    @gridLayout2.addWidget(@abilities, 0, 0, 1, 1)


    @gridLayout.addWidget(@gb, 0, 2, 2, 1)

    @spacerItem = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @gridLayout.addItem(@spacerItem, 0, 3, 1, 1)

    @spacerItem1 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @gridLayout.addItem(@spacerItem1, 1, 0, 1, 1)

    @tabs = Qt::TabWidget.new(@centralwidget)
    @tabs.objectName = "tabs"
    @tab = Qt::Widget.new()
    @tab.objectName = "tab"
    @gridLayout3 = Qt::GridLayout.new(@tab)
    @gridLayout3.objectName = "gridLayout3"
    @level = Qt::TableWidget.new(@tab)
    @level.objectName = "level"
    @level.rowCount = 20
    @level.columnCount = 14

    @gridLayout3.addWidget(@level, 0, 0, 1, 1)

    @tabs.addTab(@tab, Qt::Application.translate("MainWindow", "Level Progression", nil, Qt::Application::UnicodeUTF8))
    @tab_2 = Qt::Widget.new()
    @tab_2.objectName = "tab_2"
    @tabs.addTab(@tab_2, Qt::Application.translate("MainWindow", "Skills", nil, Qt::Application::UnicodeUTF8))

    @gridLayout.addWidget(@tabs, 2, 0, 1, 4)

    mainWindow.centralWidget = @centralwidget
    @menubar = Qt::MenuBar.new(mainWindow)
    @menubar.objectName = "menubar"
    @menubar.geometry = Qt::Rect.new(0, 0, 800, 22)
    mainWindow.setMenuBar(@menubar)
    @statusbar = Qt::StatusBar.new(mainWindow)
    @statusbar.objectName = "statusbar"
    mainWindow.statusBar = @statusbar

    retranslateUi(mainWindow)

    @tabs.setCurrentIndex(0)


    Qt::MetaObject.connectSlotsByName(mainWindow)
    end # setupUi

    def setup_ui(mainWindow)
        setupUi(mainWindow)
    end

    def retranslateUi(mainWindow)
    mainWindow.windowTitle = Qt::Application.translate("MainWindow", "DDO Chargen", nil, Qt::Application::UnicodeUTF8)
    @groupBox.title = Qt::Application.translate("MainWindow", "Basics", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("MainWindow", "Name:", nil, Qt::Application::UnicodeUTF8)
    @label_2.text = Qt::Application.translate("MainWindow", "Race:", nil, Qt::Application::UnicodeUTF8)
    @label_3.text = Qt::Application.translate("MainWindow", "Gender:", nil, Qt::Application::UnicodeUTF8)
    @label_4.text = Qt::Application.translate("MainWindow", "Alignment:", nil, Qt::Application::UnicodeUTF8)
    @label_5.text = Qt::Application.translate("MainWindow", "Buildpoints:", nil, Qt::Application::UnicodeUTF8)
    @gb.title = Qt::Application.translate("MainWindow", "Abilities", nil, Qt::Application::UnicodeUTF8)
    if @abilities.columnCount < 5
        @abilities.columnCount = 5
    end
    if @abilities.rowCount < 6
        @abilities.rowCount = 6
    end
    if @level.columnCount < 14
        @level.columnCount = 14
    end
    if @level.rowCount < 20
        @level.rowCount = 20
    end
    @tabs.setTabText(@tabs.indexOf(@tab), Qt::Application.translate("MainWindow", "Level Progression", nil, Qt::Application::UnicodeUTF8))
    @tabs.setTabText(@tabs.indexOf(@tab_2), Qt::Application.translate("MainWindow", "Skills", nil, Qt::Application::UnicodeUTF8))
    end # retranslateUi

    def retranslate_ui(mainWindow)
        retranslateUi(mainWindow)
    end

end

module Ui
    class MainWindow < Ui_MainWindow
    end
end  # module Ui

