define(['angular', 'game/yearlings-ctrl', 'ngdialog', 'ngstorage'], function (angular, yearlingsCtrl) {
  'use strict';
  var appName = 'yearlings',
      log = function () {
          var msg = Array.prototype.join.call(arguments, ' ');
          if (window.console) {
              window.console.log(msg);
          }
      };

  return {
    play: function () {
      var app;
      log('Let\'s play Yearlings!');
      app = angular.module(appName, ['ngDialog', 'angularLocalStorage']);
      app.controller(yearlingsCtrl.ctrlName, yearlingsCtrl);
      angular.bootstrap(document, [appName]);
    }
  };
});