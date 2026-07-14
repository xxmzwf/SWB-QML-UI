#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTranslator>
#include <QUrl>

#include <memory>

class LanguageController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool chinese READ chinese NOTIFY chineseChanged)

public:
    LanguageController(QGuiApplication &application, QQmlApplicationEngine &engine)
        : m_application(application)
        , m_engine(engine)
    {
    }

    bool chinese() const { return m_chinese; }

    Q_INVOKABLE void toggleLanguage()
    {
        if (m_chinese) {
            m_application.removeTranslator(&m_translator);
        } else if (!m_translator.load(QStringLiteral(":/i18n/SwbExample_zh_CN.qm"))
                   || !m_application.installTranslator(&m_translator)) {
            return;
        }

        m_chinese = !m_chinese;
        m_engine.retranslate();
        emit chineseChanged();
    }

signals:
    void chineseChanged();

private:
    QGuiApplication &m_application;
    QQmlApplicationEngine &m_engine;
    QTranslator m_translator;
    bool m_chinese = false;
};

int main(int argc, char *argv[])
{
    // Keep the custom menu bar inside the window instead of using the macOS system menu bar.
    QGuiApplication::setAttribute(Qt::AA_DontUseNativeMenuBar);
    QGuiApplication app(argc, argv);

    std::unique_ptr<LanguageController> languageController;
    QQmlApplicationEngine engine;
    languageController = std::make_unique<LanguageController>(app, engine);
    const QUrl homeVideoSource = QUrl::fromLocalFile(
        QCoreApplication::applicationDirPath() + QStringLiteral("/assets/home-bg.mp4"));
    engine.setInitialProperties({
        {QStringLiteral("languageController"), QVariant::fromValue(languageController.get())},
        {QStringLiteral("homeVideoSource"), QVariant::fromValue(homeVideoSource)},
    });
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SwbExample", "Main");

    return QGuiApplication::exec();
}

#include "main.moc"
