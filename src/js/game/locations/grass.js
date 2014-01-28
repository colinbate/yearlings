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
      };

  return {
    title: 'Grassland',
    desc: getDesc,
    onArrive: function () {
      fightStreak = 0;
      state = states.NEWLY_ARRIVED;
    },
    onLeave: function () {

    },
    onExplore: function ($scope, data) {

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
          title: 'Found a rope!',
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
    },
    actions: [
      {
        label: 'Explore field',
        act: function ($scope, data) {
          $scope.explore();
        }
      },
      {
        label: 'Enter town',
        act: function ($scope, data) {
          $scope.navigateTo(data.locations.town);
        }
      },
      {
        label: 'Explore rocky area',
        act: function ($scope, data) {
          $scope.navigateTo(data.locations.rockyland);
        }
      }
    ]
  };
});