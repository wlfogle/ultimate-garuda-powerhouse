/****************************************************************************
** Meta object code from reading C++ file 'FinishedQmlViewStep.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../src/modules/finishedq/FinishedQmlViewStep.h"
#include <QtCore/qmetatype.h>
#include <QtCore/qplugin.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'FinishedQmlViewStep.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN19FinishedQmlViewStepE_t {};
} // unnamed namespace

template <> constexpr inline auto FinishedQmlViewStep::qt_create_metaobjectdata<qt_meta_tag_ZN19FinishedQmlViewStepE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "FinishedQmlViewStep"
    };

    QtMocHelpers::UintData qt_methods {
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<FinishedQmlViewStep, qt_meta_tag_ZN19FinishedQmlViewStepE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject FinishedQmlViewStep::staticMetaObject = { {
    QMetaObject::SuperData::link<Calamares::QmlViewStep::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN19FinishedQmlViewStepE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN19FinishedQmlViewStepE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN19FinishedQmlViewStepE_t>.metaTypes,
    nullptr
} };

void FinishedQmlViewStep::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<FinishedQmlViewStep *>(_o);
    (void)_t;
    (void)_c;
    (void)_id;
    (void)_a;
}

const QMetaObject *FinishedQmlViewStep::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *FinishedQmlViewStep::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN19FinishedQmlViewStepE_t>.strings))
        return static_cast<void*>(this);
    return Calamares::QmlViewStep::qt_metacast(_clname);
}

int FinishedQmlViewStep::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = Calamares::QmlViewStep::qt_metacall(_c, _id, _a);
    return _id;
}
namespace {
struct qt_meta_tag_ZN26FinishedQmlViewStepFactoryE_t {};
} // unnamed namespace

template <> constexpr inline auto FinishedQmlViewStepFactory::qt_create_metaobjectdata<qt_meta_tag_ZN26FinishedQmlViewStepFactoryE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "FinishedQmlViewStepFactory"
    };

    QtMocHelpers::UintData qt_methods {
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<FinishedQmlViewStepFactory, qt_meta_tag_ZN26FinishedQmlViewStepFactoryE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject FinishedQmlViewStepFactory::staticMetaObject = { {
    QMetaObject::SuperData::link<CalamaresPluginFactory::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN26FinishedQmlViewStepFactoryE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN26FinishedQmlViewStepFactoryE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN26FinishedQmlViewStepFactoryE_t>.metaTypes,
    nullptr
} };

void FinishedQmlViewStepFactory::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<FinishedQmlViewStepFactory *>(_o);
    (void)_t;
    (void)_c;
    (void)_id;
    (void)_a;
}

const QMetaObject *FinishedQmlViewStepFactory::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *FinishedQmlViewStepFactory::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN26FinishedQmlViewStepFactoryE_t>.strings))
        return static_cast<void*>(this);
    if (!strcmp(_clname, "io.calamares.PluginFactory"))
        return static_cast< CalamaresPluginFactory*>(this);
    return CalamaresPluginFactory::qt_metacast(_clname);
}

int FinishedQmlViewStepFactory::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = CalamaresPluginFactory::qt_metacall(_c, _id, _a);
    return _id;
}

#ifdef QT_MOC_EXPORT_PLUGIN_V2
static constexpr unsigned char qt_pluginMetaDataV2_FinishedQmlViewStepFactory[] = {
    0xbf, 
    // "IID"
    0x02,  0x78,  0x1a,  'i',  'o',  '.',  'c',  'a', 
    'l',  'a',  'm',  'a',  'r',  'e',  's',  '.', 
    'P',  'l',  'u',  'g',  'i',  'n',  'F',  'a', 
    'c',  't',  'o',  'r',  'y', 
    // "className"
    0x03,  0x78,  0x1a,  'F',  'i',  'n',  'i',  's', 
    'h',  'e',  'd',  'Q',  'm',  'l',  'V',  'i', 
    'e',  'w',  'S',  't',  'e',  'p',  'F',  'a', 
    'c',  't',  'o',  'r',  'y', 
    0xff, 
};
QT_MOC_EXPORT_PLUGIN_V2(FinishedQmlViewStepFactory, FinishedQmlViewStepFactory, qt_pluginMetaDataV2_FinishedQmlViewStepFactory)
#else
QT_PLUGIN_METADATA_SECTION
Q_CONSTINIT static constexpr unsigned char qt_pluginMetaData_FinishedQmlViewStepFactory[] = {
    'Q', 'T', 'M', 'E', 'T', 'A', 'D', 'A', 'T', 'A', ' ', '!',
    // metadata version, Qt version, architectural requirements
    0, QT_VERSION_MAJOR, QT_VERSION_MINOR, qPluginArchRequirements(),
    0xbf, 
    // "IID"
    0x02,  0x78,  0x1a,  'i',  'o',  '.',  'c',  'a', 
    'l',  'a',  'm',  'a',  'r',  'e',  's',  '.', 
    'P',  'l',  'u',  'g',  'i',  'n',  'F',  'a', 
    'c',  't',  'o',  'r',  'y', 
    // "className"
    0x03,  0x78,  0x1a,  'F',  'i',  'n',  'i',  's', 
    'h',  'e',  'd',  'Q',  'm',  'l',  'V',  'i', 
    'e',  'w',  'S',  't',  'e',  'p',  'F',  'a', 
    'c',  't',  'o',  'r',  'y', 
    0xff, 
};
QT_MOC_EXPORT_PLUGIN(FinishedQmlViewStepFactory, FinishedQmlViewStepFactory)
#endif  // QT_MOC_EXPORT_PLUGIN_V2

QT_WARNING_POP
