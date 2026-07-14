# Example application showcasing the SwbControls library.
find_package(Qt6 REQUIRED COMPONENTS LinguistTools Multimedia)

qt_add_executable(SwbExample main.cpp)

qt_add_qml_module(SwbExample
    URI SwbExample
    VERSION 1.0
    QML_FILES
        DashboardPage.qml
        GalleryPage.qml
        HomePage.qml
        Main.qml
        RoundImage.qml
    RESOURCES
        assets/avatar.svg
        assets/github.svg
        assets/grok.jpg
        assets/huawei.jpg
        assets/icons/gear.svg
        assets/icons/dashboard.svg
        assets/icons/chat-bubble.svg
        assets/icons/chat-plus.svg
        assets/icons/chat-refresh.svg
        assets/icons/chat-send.svg
        assets/icons/grid.svg
        assets/icons/help.svg
        assets/icons/home.svg
        assets/icons/language.svg
        assets/icons/moon.svg
        assets/icons/nav-analytics.svg
        assets/icons/nav-billing.svg
        assets/icons/nav-budget.svg
        assets/icons/nav-contact.svg
        assets/icons/nav-documentation.svg
        assets/icons/nav-documents.svg
        assets/icons/nav-goals.svg
        assets/icons/nav-help-center.svg
        assets/icons/nav-investments.svg
        assets/icons/nav-notifications.svg
        assets/icons/nav-profile.svg
        assets/icons/nav-reports.svg
        assets/icons/nav-security.svg
        assets/icons/nav-spending.svg
        assets/icons/nav-status.svg
        assets/icons/nav-transactions.svg
        assets/icons/sun.svg
        assets/nvidia.jpg
        assets/openai.jpg
        assets/wechat.jpg
)

qt_add_translations(SwbExample
    TS_FILES translations/SwbExample_zh_CN.ts
    RESOURCE_PREFIX "/i18n"
)

set_target_properties(SwbExample PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Keep the large background video outside QRC so it is copied instead of compiled and linked.
add_custom_command(TARGET SwbExample POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_FILE_DIR:SwbExample>/assets"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CMAKE_CURRENT_SOURCE_DIR}/assets/home-bg.mp4"
        "$<TARGET_FILE_DIR:SwbExample>/assets/home-bg.mp4"
    COMMENT "Copying home background video"
    VERBATIM
)

# Link the control library.
target_link_libraries(SwbExample PRIVATE
    Qt6::Multimedia
    Qt6::Quick
    SwbControls
)

# Link the QML plugin explicitly for static builds so the module is registered.
# Shared builds load the plugin at runtime and must not link it directly.
if(NOT BUILD_SHARED_LIBS)
    target_link_libraries(SwbExample PRIVATE SwbControlsplugin)
endif()
