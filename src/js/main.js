/*globals require: false*/
(function () {
    'use strict';
    var THEME_KEY = 'dark-mode';
    var theme = (() => {
        if (typeof localStorage !== 'undefined' && localStorage.getItem(THEME_KEY)) {
            return localStorage.getItem(THEME_KEY);
        }
        if (!window.matchMedia('(prefers-color-scheme: dark)').matches) {
            return 'light';
        }
        return 'dark';
    })();
    document.documentElement.classList.toggle('dark', theme === 'dark');
    window.toggleDark = function() {
        let next = !document.documentElement.classList.contains('dark');
        document.documentElement.classList.toggle('dark', next);
        window.localStorage.setItem(THEME_KEY, next ? 'dark' : 'light');
    }

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