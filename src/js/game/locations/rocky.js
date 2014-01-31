define(['game/util'], function (util) {
  'use strict';
  var fightStreak = 0;

  return {
    title: 'Rocky land',
    desc: 'A large barren scrubland, this area has a rough edge to it. Be careful to mind your step here. The field and town are not too far.',
    onArrive: function () {
      fightStreak = 0;
    },
    onLeave: function () {

    },
    onExplore: function ($scope, data) {

    },
    onEncounterEnemy: function ($scope, data) {
      var enemy = util.randomFromArray(data.enemy.rocky);
      return enemy;
    },
    onFightEnemy: function () {
      fightStreak += 1;
    },
    onAvoidEnemy: function () {
      fightStreak = 0;
    },
    onFinishFighting: function ($scope, d, $q) {
      var deferred = $q.defer();
      if (fightStreak >= 3 && $scope.player.state.returnedPendant && !$scope.player.items.rope) {
        // Found cave without rope.
        $scope.inspect({
          title: $scope.currentLocation.title,
          desc: 'You come across a cave in the ground. This must the one where the sword and Morlin are. Oh great! You don\'t have a rope. Better go find one.',
          actions: [
            { label: 'Continue', act: function (scope) { fightStreak = 0; scope.finishInspecting(); } }
          ]
        });
        deferred.resolve(false);
      } else if (fightStreak >= 3 && !$scope.player.weapon.last && $scope.player.items.rope) {
        // Found cave with rope.
        $scope.inspect({
          title: $scope.currentLocation.title,
          desc: 'You come across a cave in the ground. This must the one where the sword and Morlin are. Do you want to climb in with your rope?',
          actions: [
            {
              label: 'Sure climb in!',
              act: function (scope) {
                if (scope.player.items.rope === 1) {
                  scope.player.hitPoints = 0;
                  scope.inspect({
                    title: 'YOU DIE!',
                    desc: 'Oh no!!! This rope is to weak and rotten to hold you! You plunge into the inky blackness of the cave! You land on a sharp spear of rock which thrusts itself through your frail carcass. Your last sight before you fall into eternal darkness is of a glint of metal and two glowing eyes.',
                    actions: []
                  });
                } else {
                  fightStreak = 0;
                  scope.finishInspecting();
                  deferred.resolve({boss: d.enemy.morlin});
                }
              }
            },
            { label: 'No, continue on', act: function (scope) { fightStreak = 0; scope.finishInspecting(); deferred.resolve(false); } }
          ]
        });
      }
      return deferred.promise;
    },
    actions: [
      {
        label: 'Explore rocky area',
        act: function ($scope, data) {
          $scope.explore();
        }
      },
      util.move('locations.town', 'Enter town'),
      util.move('locations.grassland', 'Go to field')
    ]
  };
});