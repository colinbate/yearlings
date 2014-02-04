/*globals require: false*/
(function () {
    'use strict';
    require.config({
        paths: {
            'lib'             : '../bower_components',
            'angular'         : '../bower_components/angular/angular.min',
            'ngdialog'        : '../bower_components/ngDialog/js/ngDialog.min',
            'ngstorage'       : '../bower_components/angularLocalStorage/src/angularLocalStorage',
            'ngcookies'       : '../bower_components/angular-cookies/angular-cookies.min'
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