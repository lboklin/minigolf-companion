#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QSettings>
#include <QQuickView>
#include <QTranslator>
#include <QLibraryInfo>

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("Minigolf Companion");
    QGuiApplication::setOrganizationName("Skaggbyran");
    QGuiApplication::setOrganizationDomain("skaggbyran.se");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setApplicationVersion("0.1");

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/images/icon.png"));

    QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(),
                      QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    app.installTranslator(&qtTranslator);

    QTranslator appTranslator;
    appTranslator.load("mgc_" + QLocale::system().name());
    app.installTranslator(&appTranslator);

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/Components/");
    engine.load(QUrl("qrc:/mgc.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
