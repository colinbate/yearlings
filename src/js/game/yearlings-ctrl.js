define(['game/data', 'game/battle'], function (data, battle) {
  'use strict';

  var yearlingsController = function ($scope, $q, storage, ngDialog) {
    var callOrReturn = function (prop, self) {
      if (typeof prop === 'function') {
        return prop.call(self, $scope, data, $q);
      }
      return prop;
    };

    $scope.savedGames = storage.get('saveindex') || [{name:'(Empty)'},{name:'(Empty)'},{name:'(Empty)'},{name:'(Empty)'},{name:'(Empty)'}];
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

    $scope.battleAction = function (action) {
      callOrReturn(action.act, $scope.currentBattle);
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

    $scope.loadDialog = function (save) {
      if (save) {
        $scope.saving = true;
        $scope.loadTitle = 'Choose a slot to save in';
        $scope.saveName = '';
      } else {
        $scope.saving = false;
        $scope.loadTitle = 'Choose a saved game to load';
      }
      ngDialog.open({
        template: 'saveScreen.html',
        className: 'ngdialog-theme-default',
        scope: $scope
      });
    };

    $scope.clickSlot = function (slot) {
      if ($scope.saving) {
        $scope.saveGame(slot, $scope.saveName);
      } else {
        $scope.loadGame(slot);
      }
      ngDialog.closeAll();
    };

    $scope.loadGame = function (slot) {
      var game = storage.get('savegame' + slot);
      if (game && game.maxHitPoints) {
        $scope.player = game;
      }
    };

    $scope.saveGame = function (slot, name) {
      name = name || 'Game ' + slot;
      $scope.savedGames[slot - 1] = {
        name: name,
        desc: 'Level ' + $scope.player.level + '; Health ' + $scope.player.hitPoints + ' / ' + $scope.player.maxHitPoints
      };
      storage.set('savegame' + slot, $scope.player);
      storage.set('saveindex', $scope.savedGames);
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
        callOrReturn($scope.currentLocation.onUninspect, $scope.currentLocation);
        $scope.currentLocation = $scope.previousLocation.pop();
      }
    };

    $scope.dieFighting = function (enemy) {
      $scope.inspect({
        title: 'YOU DIE!',
        desc: 'The ' + enemy.name + ' killed you in the battlefield. Your consolation is that your corpse will be used to feed future generations of insects and birds.',
        actions: []
      });
      $scope.currentBattle = {};
    };

    $scope.doBattle = function doBattle(enemy) {
      var locale = $scope.currentLocation,
          encounter = battle.encounter(enemy, $scope, $q),
          result;
      encounter.then(function (x) {
        callOrReturn(locale.onFightEnemy, locale);
        return battle.startFight(enemy, $scope, $q);
      }, locale.onAvoidEnemy).then(function (e) {
        if (e) {
          return callOrReturn(locale.onFinishFighting, locale);
        }
      }, function (x) {
        $scope.dieFighting(enemy);
      }).then(function (steps) {
        if (steps && steps.boss) {
          doBattle(steps.boss);
        }
      });
    };

    $scope.explore = function () {
      var explored = callOrReturn($scope.currentLocation.onExplore, $scope.currentLocation),
          enemy, encounter, result, locale;
      if (explored) {
        $scope.inspect(explored);
      } else {
        enemy = callOrReturn($scope.currentLocation.onEncounterEnemy, $scope.currentLocation);
        if (enemy) {
          $scope.doBattle(enemy);
        }
      }
    };

    $scope.levelUp = function () {
      if ($scope.player.level < 15 && $scope.player.experience > data.levels[$scope.player.level - 1]) {
        $scope.player.level += 1;
        $scope.player.attack += 2;
        $scope.player.defence += 2;
        $scope.player.maxHitPoints += 8;
        $scope.currentBattle.desc += ' You just gained a level!';
      }
    };

    $scope.debit = function (amount) {
      if ($scope.player.money >= amount) {
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
  yearlingsController.$inject = ['$scope', '$q', 'storage', 'ngDialog'];

  return yearlingsController;
});