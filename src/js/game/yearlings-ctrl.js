define([], function () {
  'use strict';

  var yearlingsController = function ($scope) {

    $scope.currentLocation = {};
    $scope.playerState = {
      weapon: {},
      armor: {},
      items: {}
    };

    // UI FUNCTIONS -----------------------------------------

    $scope.showStats = function () {
      return $scope.playerState.maxHitPoints;
    }

    // STATE MANIPULATION FUNCTIONS -------------------------

    $scope.debit = function (amount) {
      $scope.
    };
  };
  yearlingsController.ctrlName = 'YearlingsController';
  yearlingsController.$inject = ['$scope'];

  return yearlingsController;
});