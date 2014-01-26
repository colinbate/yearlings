define(['game/data', 'game/battle'], function (data, battle) {
  'use strict';

  var yearlingsController = function ($scope, $q) {
    var callOrReturn = function (prop, self) {
      if (typeof prop === 'function') {
        return prop.call(self, $scope, data);
      }
      return prop;
    };

    $scope.currentLocation = {};
    $scope.currentBattle = {};
    $scope.previousLocation = [];
    $scope.player = {
      weapon: {},
      armor: {},
      items: {}
    };

    // UI FUNCTIONS -----------------------------------------

    $scope.showStats = function () {
      return $scope.player.maxHitPoints;
    };

    $scope.inBattle = function () {
      return $scope.currentBattle.name;
    };

    $scope.getCurrentLocationTitle = function () {
      return callOrReturn($scope.currentLocation.title, $scope.currentLocation);
    };

    $scope.getCurrentLocationDesc = function () {
      return callOrReturn($scope.currentLocation.desc, $scope.currentLocation);
    };

    $scope.getActionLabel = function (action) {
      return callOrReturn(action.label, action);
    };

    $scope.takeAction = function (action) {
      callOrReturn(action.act, action);
    };

    // STATE MANIPULATION FUNCTIONS -------------------------

    $scope.startGame = function () {
      $scope.currentLocation = data.locations.grassland;
      $scope.player.money = 150;
      $scope.player.hitPoints = 30;
      $scope.player.level = 1;
      $scope.player.attack = 4;
      $scope.player.defence = 3;
      $scope.player.experience = 0;
      $scope.player.items = {
        bombs: 0,
        cure: 0
      };
      $scope.player.maxHitPoints = 30;
      $scope.player.weapon = {};
      $scope.player.armor = {};
      $scope.player.state = {};
    };

    $scope.navigateTo = function (location) {
      if ($scope.currentLocation !== location) {
        callOrReturn($scope.currentLocation.onLeave, $scope.currentLocation);
        $scope.currentLocation = location;
        callOrReturn($scope.currentLocation.onArrive, $scope.currentLocation);
        $scope.previousLocation = [];
      }
    };

    $scope.inspect = function (location) {
      if ($scope.currentLocation !== location) {
        $scope.previousLocation.push($scope.currentLocation);
        $scope.currentLocation = location;
        callOrReturn($scope.currentLocation.onInspect, $scope.currentLocation);
      }
    };

    $scope.finishInspecting = function () {
      if ($scope.previousLocation.length > 0) {
        $scope.currentLocation = $scope.previousLocation.pop();
      }
    };

    $scope.explore = function () {
      var explored = callOrReturn($scope.currentLocation.onExplore, $scope.currentLocation),
          enemy, encounter;
      if (explored) {
        $scope.inspect(explored);
      } else {
        enemy = callOrReturn($scope.currentLocation.onEncounterEnemy, $scope.currentLocation);
        if (enemy) {
          encounter = battle.encounter(enemy, $scope, $q);
          encounter.then($scope.currentLocation.onFightEnemy, $scope.currentLocation.onAvoidEnemy)
        }
      }
    };

    $scope.debit = function (amount) {
      if ($scope.player.money > amount) {
        $scope.player.money -= amount;
        return true;
      }
      return false;
    };

    $scope.credit = function (amount) {
      $scope.player.money += amount;
      return true;
    };

    $scope.startGame();

  };
  yearlingsController.ctrlName = 'YearlingsController';
  yearlingsController.$inject = ['$scope', '$q'];

  return yearlingsController;
});