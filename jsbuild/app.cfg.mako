#
# This is the config file for jsbuild utility
# Documentation on the syntax of this file is available at:
# http://pypi.python.org/pypi/JSTools#configuration-format
#

#
# Notes:
#
# Language files are in the lang-*.js builds. Except for one file:
# OpenLayers/Lang.js. This is tricky. This one is included in the main build,
# e.g. app.js. The thing is that OpenLayers/Lang.js requires
# OpenLayers/SingleFile.js, which resets the OpenLayers (root) object.  And we
# can obviously not reset the OpenLayers object when evaluating lang-*.js.
#
# Warning: when adding a comment whose leading "#" is not on the first
# column in the file do not add a space between the "#" character and
# the actual comment. For example, use "#GXP", not "# GXP". Really,
# this should be fixed in jsbuild.
#

<%
root = [
    "demo/static/lib/cgxp/core/src/script",
    "demo/static/lib/cgxp/ext",
    "demo/static/lib/cgxp/geoext/lib",
    "demo/static/lib/cgxp/openlayers/lib",
    "demo/static/lib/cgxp/openlayers.addins/GoogleEarthView/lib",
    "demo/static/lib/cgxp/openlayers.addins/Spherical/lib",
    "demo/static/lib/cgxp/openlayers.addins/URLCompressed/lib",
    "demo/static/lib/cgxp/openlayers.addins/DynamicMeasure/lib",
    "demo/static/lib/cgxp/openlayers.addins/AddViaPoint/lib",
    "demo/static/lib/cgxp/openlayers.addins/AutoProjection/lib",
    "demo/static/lib/cgxp/gxp/src/script",
    "demo/static/lib/cgxp/proj4js",
    "demo/static/lib/cgxp/geoext.ux/ux/Measure/lib",
    "demo/static/lib/cgxp/geoext.ux/ux/SimplePrint/lib",
    "demo/static/lib/cgxp/geoext.ux/ux/FeatureEditing/lib",
    "demo/static/lib/cgxp/geoext.ux/ux/FeatureSelectionModel/lib",
    "demo/static/lib/cgxp/geoext.ux/ux/WMSBrowser/lib",
    "demo/static/lib/cgxp/geoext.ux/ux/StreetViewPanel",
    "demo/static/lib/cgxp/sandbox",
    "demo/static/lib/cgxp/styler/lib",
    "demo/static/lib/cgxp/ext.ux/TwinTriggerComboBox",
    "demo/static/lib/cgxp/ext.ux/GroupComboBox",
    "demo/static/lib/cgxp/ext.ux/ColorPicker",
    "demo/static/lib/cgxp/ext.ux/base64",
    "demo/static/lib/cgxp/ext.overrides",
    "demo/static/lib/cgxp/dygraphs",
    "demo/static/js",
]
%>

[app.js]
root =
    ${"\n    ".join(root)}
first =
    Ext/adapter/ext/ext-base-debug.js
    Ext/ext-all-debug.js
    OpenLayers/SingleFile.js
    OpenLayers/Console.js
    OpenLayers/BaseTypes.js
    OpenLayers/BaseTypes/Class.js
    OpenLayers/BaseTypes/Pixel.js
    OpenLayers/BaseTypes/Bounds.js
    OpenLayers/BaseTypes/LonLat.js
    OpenLayers/BaseTypes/Element.js
    OpenLayers/BaseTypes/Size.js
    OpenLayers/Util.js
    OpenLayers/Lang.js
    proj4js/lib/proj4js.js
    proj4js/lib/projCode/merc.js
exclude =
    GeoExt.js
    GeoExt/SingleFile.js
include =
    EPSG21781.js #proj4js
    EPSG2056.js #proj4js
    util.js #GXP
    widgets/Viewer.js #GXP
    Ext/ux/form/GroupComboBox.js
    CGXP/cgxp.js
    CGXP/plugins/WFSPermalink.js
    CGXP/plugins/ThemeSelector.js
    CGXP/plugins/LocationChooser.js
    CGXP/plugins/ThemeFinder.js
    CGXP/plugins/LayerTree.js
    CGXP/plugins/FeaturesGrid.js
    CGXP/plugins/FeaturesWindow.js
    CGXP/plugins/GoogleEarthView.js
    CGXP/plugins/StreetView.js
    CGXP/plugins/WMSBrowser.js
    CGXP/plugins/AddKMLFile.js
    CGXP/plugins/Profile.js
    CGXP/plugins/Zoom.js
    CGXP/plugins/GetFeature.js
    CGXP/plugins/ScaleChooser.js
    CGXP/plugins/MapOpacitySlider.js
    CGXP/plugins/MenuShortcut.js
    CGXP/plugins/Print.js
    CGXP/plugins/Legend.js
    CGXP/plugins/Help.js
    CGXP/plugins/QueryBuilder.js
    CGXP/plugins/Login.js
    CGXP/plugins/Measure.js
    CGXP/plugins/FullTextSearch.js
    CGXP/plugins/Permalink.js
    CGXP/plugins/Disclaimer.js
    CGXP/plugins/ContextualData.js
    CGXP/widgets/MapPanel.js
    CGXP/plugins/Redlining.js
    CGXP/plugins/MyPosition.js
    CGXP/tools/tools.js
    OpenLayers/Control/Navigation.js
    OpenLayers/Control/PinchZoom.js
    OpenLayers/Control/KeyboardDefaults.js
    OpenLayers/Control/PanZoomBar.js
    OpenLayers/Control/ArgParser.js
    OpenLayers/Control/Attribution.js
    OpenLayers/Control/ScaleLine.js
    OpenLayers/Control/MousePosition.js
    OpenLayers/Control/OverviewMap.js
    OpenLayers/Control/NavigationHistory.js
    OpenLayers/Layer/WMTS.js
    OpenLayers/Layer/WMS.js
    OpenLayers/Layer/OSM.js
    OpenLayers/Layer/Vector.js
    OpenLayers/Renderer/SVG.js
    OpenLayers/Renderer/VML.js
    plugins/OLSource.js #GXP
    plugins/OSMSource.js #GXP
    plugins/ZoomToExtent.js #GXP
    plugins/NavigationHistory.js #GXP
    plugins/ZoomToExtent.js #GXP
    plugins/NavigationHistory.js #GXP
    proj4js/lib/projCode/merc.js

[edit.js]
root =
    ${"\n    ".join(root)}
first =
    Ext/adapter/ext/ext-base-debug.js
    Ext/ext-all-debug.js
    OpenLayers/SingleFile.js
    OpenLayers/Console.js
    OpenLayers/BaseTypes.js
    OpenLayers/BaseTypes/Class.js
    OpenLayers/BaseTypes/Pixel.js
    OpenLayers/BaseTypes/Bounds.js
    OpenLayers/BaseTypes/LonLat.js
    OpenLayers/BaseTypes/Element.js
    OpenLayers/BaseTypes/Size.js
    OpenLayers/Util.js
    OpenLayers/Lang.js
    proj4js/lib/proj4js.js
    proj4js/lib/projCode/merc.js
exclude =
    GeoExt.js
    GeoExt/SingleFile.js
include =
    EPSG2056.js #proj4js
    EPSG21781.js #proj4js
    util.js #GXP
    widgets/Viewer.js #GXP
    CGXP/cgxp.js
    CGXP/plugins/Editing.js
    CGXP/plugins/Login.js
    CGXP/plugins/FullTextSearch.js
    CGXP/plugins/Permalink.js
    CGXP/plugins/ThemeSelector.js
    CGXP/plugins/MapOpacitySlider.js
    CGXP/plugins/LayerTree.js
    CGXP/plugins/MenuShortcut.js
    CGXP/plugins/MyPosition.js
    CGXP/widgets/MapPanel.js
    CGXP/tools/tools.js
    OpenLayers/Control/Navigation.js
    OpenLayers/Control/PinchZoom.js
    OpenLayers/Control/KeyboardDefaults.js
    OpenLayers/Control/PanZoomBar.js
    OpenLayers/Control/ArgParser.js
    OpenLayers/Control/Attribution.js
    OpenLayers/Control/ScaleLine.js
    OpenLayers/Control/MousePosition.js
    OpenLayers/Control/OverviewMap.js
    OpenLayers/Control/NavigationHistory.js
    OpenLayers/Layer/Vector.js
    OpenLayers/Layer/OSM.js
    OpenLayers/Layer/WMTS.js
    OpenLayers/Renderer/SVG.js
    OpenLayers/Renderer/VML.js
    proj4js/lib/projCode/merc.js
    plugins/OLSource.js #GXP
    plugins/OSMSource.js #GXP

[routing.js]
root =
    ${"\n    ".join(root)}
first =
    Ext/adapter/ext/ext-base-debug.js
    Ext/ext-all-debug.js
    OpenLayers/SingleFile.js
    OpenLayers/Console.js
    OpenLayers/BaseTypes.js
    OpenLayers/BaseTypes/Class.js
    OpenLayers/BaseTypes/Pixel.js
    OpenLayers/BaseTypes/Bounds.js
    OpenLayers/BaseTypes/LonLat.js
    OpenLayers/BaseTypes/Element.js
    OpenLayers/BaseTypes/Size.js
    OpenLayers/Util.js
    OpenLayers/Lang.js
    proj4js/lib/proj4js.js
    proj4js/lib/projCode/merc.js
exclude =
    GeoExt.js
    GeoExt/SingleFile.js
include =
    EPSG21781.js #proj4js
    EPSG2056.js #proj4js
    util.js #GXP
    widgets/Viewer.js #GXP
    CGXP/cgxp.js
    CGXP/plugins/MapOpacitySlider.js
    CGXP/plugins/Routing.js
    CGXP/data/OSRM.js
    CGXP/widgets/MapPanel.js
    CGXP/tools/tools.js
    OpenLayers/Control/Navigation.js
    OpenLayers/Control/PinchZoom.js
    OpenLayers/Control/KeyboardDefaults.js
    OpenLayers/Control/PanZoomBar.js
    OpenLayers/Control/ArgParser.js
    OpenLayers/Control/Attribution.js
    OpenLayers/Control/ScaleLine.js
    OpenLayers/Control/MousePosition.js
    OpenLayers/Control/OverviewMap.js
    OpenLayers/Control/NavigationHistory.js
    OpenLayers/Layer/Vector.js
    OpenLayers/Layer/OSM.js
    OpenLayers/Layer/WMTS.js
    OpenLayers/Renderer/SVG.js
    OpenLayers/Renderer/VML.js
    proj4js/lib/projCode/merc.js
    plugins/OLSource.js #GXP
    plugins/OSMSource.js #GXP

[lang-en.js]
root =
    ${"\n    ".join(root)}
first =
    OpenLayers/Lang/en.js
include =
    Proj/Lang/en.js
    Ext/src/locale/ext-lang-en.js
    Proj/Lang/GeoExt-en.js
#    FeatureEditing/resources/lang/en.js
    Styler/lang/en.js
    locale/en.js #GXP
exclude =
    OpenLayers/Lang.js

[lang-fr.js]
root =
    ${"\n    ".join(root)}
first =
    OpenLayers/Lang/fr.js
include =
    Ext/src/locale/ext-lang-fr.js
    FeatureEditing/resources/lang/fr.js
    GeoExt.ux/locale/WMSBrowser-fr.js
    ux/locale/StreetViewPanel-fr.js
    Styler/lang/fr.js
    locale/SimplePrint-fr.js
    locale/fr.js #GXP
    CGXP/locale/fr.js
last =
    Proj/Lang/fr.js
    Proj/Lang/GeoExt-fr.js
exclude =
    OpenLayers/Lang.js

[lang-de.js]
root =
    ${"\n    ".join(root)}
first =
    OpenLayers/Lang/de.js
include =
    Ext/src/locale/ext-lang-de.js
    FeatureEditing/resources/lang/de.js
    GeoExt.ux/locale/WMSBrowser-de.js
    ux/locale/StreetViewPanel-de.js
    locale/SimplePrint-de.js
    Styler/lang/de.js
#    locale/de.js #GXP
    CGXP/locale/de.js
last =
    Proj/Lang/de.js
    Proj/Lang/GeoExt-de.js
exclude =
    OpenLayers/Lang.js

[api.js]
root =
    ${"\n    ".join(root)}
first =
    OpenLayers/SingleFile.js
    OpenLayers/Console.js
    OpenLayers/BaseTypes.js
    OpenLayers/BaseTypes/Class.js
    OpenLayers/BaseTypes/Pixel.js
    OpenLayers/BaseTypes/Bounds.js
    OpenLayers/BaseTypes/LonLat.js
    OpenLayers/BaseTypes/Element.js
    OpenLayers/BaseTypes/Size.js
    OpenLayers/Util.js
    OpenLayers/Lang.js
    proj4js/lib/proj4js.js
    proj4js/lib/projCode/merc.js
include =
    EPSG2056.js #proj4js
    EPSG21781.js #proj4js
    OpenLayers/Control/Navigation.js
    OpenLayers/Control/PinchZoom.js
    OpenLayers/Control/PanZoomBar.js
    OpenLayers/Control/ArgParser.js
    OpenLayers/Control/Attribution.js
    OpenLayers/Control/ScaleLine.js
    OpenLayers/Control/MousePosition.js
    OpenLayers/Control/OverviewMap.js
    OpenLayers/Control/LayerSwitcher.js
    OpenLayers/Layer/WMTS.js
    OpenLayers/Layer/OSM.js
    OpenLayers/Layer/TMS.js
    CGXP/api/Map.js
    proj4js/lib/projCode/merc.js

[api-lang-en.js]
root =
    ${"\n    ".join(root)}
first =
    OpenLayers/Lang/en.js
include =
    Proj/Lang/en.js
exclude =
    OpenLayers/Lang.js

[api-lang-fr.js]
root =
    ${"\n    ".join(root)}
first =
    OpenLayers/Lang/fr.js
include =
    Proj/Lang/fr.js
exclude =
    OpenLayers/Lang.js

[api-lang-de.js]
root =
    ${"\n    ".join(root)}
first =
    OpenLayers/Lang/de.js
include =
    Proj/Lang/de.js
exclude =
    OpenLayers/Lang.js

[xapi.js]
root =
    ${"\n    ".join(root)}
first =
    Ext/adapter/ext/ext-base-debug.js
    Ext/ext-all-debug.js
    GeoExt/Lang.js
    OpenLayers/SingleFile.js
    OpenLayers/Console.js
    OpenLayers/BaseTypes.js
    OpenLayers/BaseTypes/Class.js
    OpenLayers/BaseTypes/Pixel.js
    OpenLayers/BaseTypes/Bounds.js
    OpenLayers/BaseTypes/LonLat.js
    OpenLayers/BaseTypes/Element.js
    OpenLayers/BaseTypes/Size.js
    OpenLayers/Util.js
    OpenLayers/Lang.js
    proj4js/lib/proj4js.js
    proj4js/lib/projCode/merc.js
include =
    EPSG21781.js #proj4js
    EPSG2056.js  #proj4js
    util.js #GXP
    widgets/Viewer.js #GXP
    CGXP/cgxp.js
    CGXP/api/Map.js
    CGXP/plugins/Zoom.js
    CGXP/plugins/Redlining.js
    CGXP/plugins/MapOpacitySlider.js
    CGXP/plugins/MenuShortcut.js
    CGXP/plugins/Legend.js
    CGXP/plugins/Help.js
    CGXP/plugins/Measure.js
    CGXP/plugins/FullTextSearch.js
    CGXP/plugins/Disclaimer.js
    CGXP/widgets/MapPanel.js
    OpenLayers/Control/Navigation.js
    OpenLayers/Control/PinchZoom.js
    OpenLayers/Control/PanZoomBar.js
    OpenLayers/Control/ArgParser.js
    OpenLayers/Control/Attribution.js
    OpenLayers/Control/ScaleLine.js
    OpenLayers/Control/MousePosition.js
    OpenLayers/Control/NavigationHistory.js
    OpenLayers/Control/OverviewMap.js
    OpenLayers/Control/LayerSwitcher.js
    OpenLayers/Layer/WMTS.js
    OpenLayers/Layer/TMS.js
    plugins/OLSource.js #GXP
    plugins/OSMSource.js #GXP
    plugins/ZoomToExtent.js #GXP
    plugins/NavigationHistory.js #GXP
    proj4js/lib/projCode/merc.js
exclude =
    GeoExt.js
    GeoExt/SingleFile.js
