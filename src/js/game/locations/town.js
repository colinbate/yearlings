define(['game/util'], function (util) {
  'use strict';
  var tellerMessages = [
    'The evil spirit Kamul haunts the Doomed Woods.',
    'Enemies in the grassland are easier than those in the rocky land.',
    'If I were you, I\'d  get to level 13 before even going into the forest.',
    'The Item Shop teller has more than he sells.',
    'I can\'t find my magical pendant, I think I lost it some where in the field.'
  ];

  return {
    title: 'Town of Pylaim',
    desc: 'You take a look around the town. You see weapon and armour shops plus a general store. On the other side of town you see a monitor station and a fortune tellers tent.',
    onEncounterEnemy: false,
    actions: [
      {
        label: 'Weapon Shop',
        act: function ($scope, data) {

        }
      },
      {
        label: 'Armour Shop',
        act: function ($scope, data) {

        }
      },
      {
        label: 'General Store',
        act: function ($scope, data) {

        }
      },
      {
        label: 'Monitor Station',
        act: function ($scope, data) {
          $scope.inspect(data.locations.monitor);
        }
      },
      {
        label: 'Fortune Teller',
        act: function ($scope, data) {
          $scope.inspect(data.locations.town.places.teller);
        }
      },
      {
        label: 'Leave town',
        act: function ($scope, data) {
          $scope.navigateTo(data.locations.grassland);
        }
      },
    ],
    places: {
      teller: {
        title: 'Fortune Teller',
        desc: function ($scope) {
          var msg = '';
          if ($scope.player.items.pendant) {
            msg = 'Thank you so much for finding my pendant, to repay you I will tell you about the Dragon\'s Bane. It is a mystical sword that is guarded by a wizard name Morlin in a cave not far from here. Explore the rocky area to find it.';
            delete $scope.player.items['pendant'];
            $scope.player.state.returnedPendant = true;
          } else if ($scope.player.weapon.name === 'Dragon\'s Bane') {
            msg = 'Now that you have the Dragon\'s Bane you are unstoppable! GO - KILL KAMUL!!';
          } else if ($scope.player.state.returnedPendant) {
            msg = 'Go! Find the sword and defeat the evil spirit Kamul!';
          } else {
            msg = tellerMessages[Math.min($scope.player.level - 1, 4)];
          }
          return '"' + msg + '"';
        },
        actions: [util.leave('Leave the tent')]
      }
    }
  };
});