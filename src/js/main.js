/*globals require: false*/
(function () {
    'use strict';
    require.config({
        paths: {
            'lib'             : '../bower_components',
            'angular'         : '../bower_components/angular/angular.min'
        },
        shim: {
            'angular'         : { exports: 'angular' }
        }
    });

    require(['game/start'], function (game) {
        game.play();
    });
}());