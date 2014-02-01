define(['game/util'], function (util) {
  'use strict';
  var states = { NEW_GAME: 0, NEWLY_ARRIVED: 1, ALREADY_HERE: 2 },
      state = 0,
      fightStreak = 0,
      getDesc = function () {
        var initial = 'The mist settles and you find yourself in a grassy field. There is a town nearby. The field is bordered on the West by a dense forest. There seems to be a powerful negative aura given off by the forest. You decide to stay out of the forest for the time being. To the East is a barren rocky area. This is some strange terrain, you think to yourself.';
        if (state === states.NEW_GAME) {
          return initial;
        } else {
          return 'You are in the field. The town, forest, and rocky area border the field.';
        }
      },
      checkForWoods = function ($scope, actions) {
        if ($scope.player.level >= 13 && actions.length === 3) {
          actions.push(util.move('locations.forest', 'Doomed Woods'));
        }
      };

  return {
    title: 'Grassland',
    desc: getDesc,
    onArrive: function ($scope) {
      fightStreak = 0;
      state = states.NEWLY_ARRIVED;
      checkForWoods($scope, this.actions);
    },
    onEncounterEnemy: function ($scope, data) {
      var enemy = util.randomFromArray(data.enemy.grass);
      state = states.ALREADY_HERE;
      return enemy;
    },
    onFightEnemy: function () {
      fightStreak += 1;
    },
    onAvoidEnemy: function () {
      fightStreak = 0;
    },
    onFinishFighting: function ($scope) {
      checkForWoods($scope, this.actions);
      if (fightStreak >= 3 && !$scope.player.items.pendant && !$scope.player.state.returnedPendant) {
        // Found pendant.
        $scope.inspect({
          title: $scope.currentLocation.title,
          desc: 'You found a pendant in the grass!',
          actions: [
            {
              label: 'Pick it up',
              act: function (scope) {
                scope.player.items.pendant = true;
                fightStreak = 0;
                scope.finishInspecting();
              }
            },
            { label: 'Leave it', act: function (scope) { fightStreak = 0; scope.finishInspecting(); } }
          ]
        });
      } else if (fightStreak >= 3 && $scope.player.state.returnedPendant && !$scope.player.items.rope) {
        // Found rope.
        $scope.inspect({
          title: $scope.currentLocation.title,
          desc: 'You found a rope tangled in a tree!',
          actions: [
            {
              label: 'Take it',
              act: function (scope) {
                scope.player.items.rope = 1;
                fightStreak = 0;
                scope.finishInspecting();
              }
            },
            { label: 'Leave it', act: function (scope) { fightStreak = 0; scope.finishInspecting(); } }
          ]
        });
      }
      return false;
    },
    actions: [
      {
        label: 'Explore field',
        act: function ($scope, data) {
          $scope.explore();
        }
      },
      util.move('locations.town', 'Enter town'),
      util.move('locations.rockyland', 'Go to rocky area')
    ]
  };
});