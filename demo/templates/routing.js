## -*- coding: utf-8 -*-
<%
from json import dumps
%>
Ext.onReady(function() {
    /*
     * Initialize the application.
     */
    // OpenLayers
    OpenLayers.Number.thousandsSeparator = ' ';
    OpenLayers.DOTS_PER_INCH = 72;

    // Ext
    Ext.QuickTips.init();

    OpenLayers.ImgPath = "${request.static_url('demo:static/lib/cgxp/core/src/theme/img/ol/') | n}";
    Ext.BLANK_IMAGE_URL = "${request.static_url('demo:static/lib/cgxp/ext/Ext/resources/images/default/s.gif') | n}";

    // Apply same language than on the server side
    OpenLayers.Lang.setCode("${lang}");
    GeoExt.Lang.set("${lang}");

    // Server errors (if any)
    var serverError = ${serverError | n};

    // Themes definitions
    var THEMES = {
        "local": ${themes | n}
% if external_themes:
        , "external": ${external_themes | n}
% endif
    };

    <% bounds = user.role.bounds if user else None %>
% if bounds:
    var INITIAL_EXTENT = ${dumps(bounds)};
% else:
    var INITIAL_EXTENT = [529000, 147000, 555000, 161000];
% endif
    var MAX_EXTENT = [420000, 30000, 900000, 350000];
    var RESTRICTED_EXTENT = [420000, 40500, 839000, 306400];

    // Used to transmit event throw the application
    var EVENTS = new Ext.util.Observable();

    var WMTSASITVD_OPTIONS2 = {
        url: "https://ows.asitvd.ch/wmts/",
        attribution: OpenLayers.i18n("© <a href='https://asitvd.ch'>ASIT VD</a>, Contributeurs d’<a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a>"),
        displayInLayerSwitcher: false,
        requestEncoding: 'REST',
        buffer: 0,
        style: 'default',
        dimensions: ['DIM1','ELEVATION'],
        params: {
            'dim1': 'default',
            'elevation': '0'
        },
        matrixSet: "21781",
        maxExtent: MAX_EXTENT,
        projection: new OpenLayers.Projection("EPSG:21781"),
        units: "m",
        format: "image/png",
        formatSuffix: 'png',
        opacity: 1,
        visibility: true,
        serverResolutions: [4000.0,3750.0,3500.0,3250.0,3000.0,2750.0,2500.0,2250.0,2000.0,1750.0,1500.0,1250.0,1000.0,750.0,650.0,500.0,250.0,100.0,50.0,20.0,10.0,5.0,2.5,2.0,1.5,1.0,0.5,0.25,0.1,0.05]
    };

    app = new gxp.Viewer({

        // viewer config
        portalConfig: {
            ctCls: 'x-map',
            layout: 'border',
            items: [
                'app-map',
            {
                id: 'left-panel',
                region: 'west',
                layout: 'fit',
                width: 405
            }]
        },

        // tools
        tools: [
        {
            ptype: 'cgxp_routing',
            routingService: {
                osrm_demo: {
                    type: 'OSRM',
                    url: 'https://router.project-osrm.org/',
                    dynamic: true
                }
            },
            searchOptions: {
                url: "${request.route_url('fulltextsearch') | n}",
            },
            outputConfig: {
                zoomToRouteLevel: 16
            },
            outputTarget: 'left-panel'
        },
        {
            ptype: "cgxp_mapopacityslider",
            defaultBaseLayerRef: "${functionality['default_basemap'][0] | n}",
            orthoRef: undefined
        }
        ],

        // layer sources
        sources: {
            "olsource": {
                ptype: "gxp_olsource"
            }
        },

        // map and layers
        map: {
            id: "app-map", // id needed to reference map in portalConfig above
            xtype: 'cgxp_mappanel',
            projectionCodes: [21781, 2056, 4326],
            extent: INITIAL_EXTENT,
            maxExtent: MAX_EXTENT,
            restrictedExtent: RESTRICTED_EXTENT,
            stateId: "map",
            projection: new OpenLayers.Projection("EPSG:21781"),
            units: "m",
            resolutions: [200, 100, 50, 20, 10, 5, 2, 1, 0.5, 0.25, 0.1, 0.05],
            controls: [
                new OpenLayers.Control.Navigation(),
                new OpenLayers.Control.KeyboardDefaults(),
                new OpenLayers.Control.PanZoomBar({
                    panIcons: false,
                    zoomWorldIcon: true
                }),
                new OpenLayers.Control.ArgParser(),
                new OpenLayers.Control.Attribution(),
                new OpenLayers.Control.ScaleLine({
                    geodesic: true,
                    bottomInUnits: false,
                    bottomOutUnits: false
                }),
                new OpenLayers.Control.MousePosition({numDigits: 0})
            ],
            layers: [{
                source: "olsource",
                type: "OpenLayers.Layer.WMTS",
                group: 'background',
                args: [Ext.applyIf({
                    name: OpenLayers.i18n('asitvd.fond_couleur'),
                    ref: 'asitvd.fond_couleur',
                    layer: 'asitvd.fond_couleur',
                    queryLayers: [],
                    transitionEffect: "resize",
                    group: 'background',
                    visibility: false
                }, WMTSASITVD_OPTIONS2)]
            },
            {
                source: "olsource",
                type: "OpenLayers.Layer.WMTS",
                group: 'background',
                args: [Ext.applyIf({
                    name: OpenLayers.i18n('asitvd.fond_gris'),
                    ref: 'asitvd.fond_gris',
                    layer: 'asitvd.fond_gris',
                    queryLayers: [],
                    transitionEffect: "resize",
                    group: 'background',
                    visibility: false
                }, WMTSASITVD_OPTIONS2)]
            },
            {
                source: "olsource",
                type: "OpenLayers.Layer",
                group: 'background',
                args: [OpenLayers.i18n('blank'), {
                    displayInLayerSwitcher: false,
                    ref: 'blank',
                    group: 'background',
                    opacity: 0
                }]
            }],
            items: []
        }
    });

    app.on('ready', function() {
        // remove loading message
        Ext.get('loading').remove();
        Ext.fly('loading-mask').fadeOut({
            remove: true
        });

        if (serverError.length > 0) {
            cgxp.tools.openWindow({
                html: serverError.join('<br />')
            }, OpenLayers.i18n("Error notice"), 600, 500);
        }
    }, app);
});
