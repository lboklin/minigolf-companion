TEMPLATE = app
TARGET = minigolf-companion
QT += quick quickcontrols2 svg

SOURCES += \
    mgc.cpp

lupdate_only {
    SOURCES = \
        *.qml \
        *.js \
        pages/*.qml \
        pages/*.js \
        Components/*.qml \
        Components/*.js
}

OTHER_FILES += \
    Components/*.qml \
    pages/*.qml \
    *.qml

RESOURCES += \
    mgc.qrc

TRANSLATIONS = mgc_sv_se.ts

DISTFILES += \
    LICENSE \
    README.md \
    Components/FlatButton.qml \
    pages/SwipeView.qml

android {
    DISTFILES += \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradlew \
        android/res/values/libs.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew.bat

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}
