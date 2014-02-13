/*globals require: false*/
(function () {
    'use strict';
    require.config({
        paths: {
            'lib'             : '../libs',
            'angular'         : '../libs/angular',
            'ngdialog'        : '../libs/ngDialog',
            'ngstorage'       : '../libs/angularLocalStorage',
            'ngcookies'       : '../libs/angular-cookies'
        },
        shim: {
            'angular'         : { exports: 'angular' },
            'ngdialog'        : ['angular'],
            'ngcookies'       : ['angular'],
            'ngstorage'       : ['angular', 'ngcookies'],
        },
        waitSeconds: 15
    });

    require(['game/start'], function (game) {
        game.play();
    });
}());