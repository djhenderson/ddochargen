=begin
** Form generated from reading ui file 'SelectClass.ui'
**
** Created: Wed Feb 3 13:25:55 2010
**      by: Qt User Interface Compiler version 4.5.3
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_SelectClass
    attr_reader :buttonBox
    attr_reader :classes

    def setupUi(selectClass)
    if selectClass.objectName.nil?
        selectClass.objectName = "selectClass"
    end
    selectClass.resize(400, 300)
    @buttonBox = Qt::DialogButtonBox.new(selectClass)
    @buttonBox.objectName = "buttonBox"
    @buttonBox.geometry = Qt::Rect.new(30, 240, 341, 32)
    @buttonBox.orientation = Qt::Horizontal
    @buttonBox.standardButtons = Qt::DialogButtonBox::Cancel|Qt::DialogButtonBox::Ok
    @classes = Qt::ListWidget.new(selectClass)
    @classes.objectName = "classes"
    @classes.geometry = Qt::Rect.new(20, 20, 361, 201)

    retranslateUi(selectClass)
    Qt::Object.connect(@buttonBox, SIGNAL('accepted()'), selectClass, SLOT('accept()'))
    Qt::Object.connect(@buttonBox, SIGNAL('rejected()'), selectClass, SLOT('reject()'))

    Qt::MetaObject.connectSlotsByName(selectClass)
    end # setupUi

    def setup_ui(selectClass)
        setupUi(selectClass)
    end

    def retranslateUi(selectClass)
    selectClass.windowTitle = Qt::Application.translate("SelectClass", "Select a class", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(selectClass)
        retranslateUi(selectClass)
    end

end

module Ui
    class SelectClass < Ui_SelectClass
    end
end  # module Ui

