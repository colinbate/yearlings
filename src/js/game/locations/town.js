define(['game/util'], function (util) {
  'use strict';
  var tellerMessages = [
    'The evil spirit Kamul haunts the Doomed Woods.',
    'Enemies in the grassland are easier than those in the rocky land.',
    'If I were you, I\'d  get to level 13 before even going into the forest.',
    'The Item Shop teller has more than he sells.',
    'I can\'t find my magical pendant, I think I lost it some where in the field.'
  ],
  confirmDowngrade = function (done, scope, desc) {
    return {
      title: scope.currentLocation.title,
      desc: desc || 'That is cheaper than the one you have now, are you sure?',
      actions: [
        { label: 'Yes', act: function () { done(true); scope.finishInspecting(); } },
        { label: 'No', act: function () { done(false); scope.finishInspecting(); } }
      ]
    };
  },
  buyThis = function (presaleFn, saleFn) {
    return function (scope) {
      var self = this;
      presaleFn(self.item, function (yes) {
        if (yes && scope.debit(self.item.price)) {
          saleFn(self.item);
        }
      });
    };
  },
  addItemsForSale = function (dest, src, presaleFn, saleFn) {
    var ii;
    for (ii = src.length - 1; ii >= 0; ii -= 1) {
      if (src[ii].price > 0) {
        dest.unshift({
          label: src[ii].name + ' (' + src[ii].price + ')',
          item: src[ii],
          act: buyThis(presaleFn, saleFn)
        });
      }
    }
  };

  return {
    title: 'Town of Pylaim',
    desc: 'You take a look around the town. You see weapon and armour shops plus a general store. On the other side of town you see a monitor station and a fortune tellers tent.',
    onEncounterEnemy: false,
    actions: [
      util.visit('locations.town.shops.weapon'),
      util.visit('locations.town.shops.armor'),
      util.visit('locations.town.shops.general'),
      util.visit('locations.town.places.monitor'),
      util.visit('locations.town.places.teller'),
      util.move('locations.grassland', 'Leave town')
    ],
    places: {
      monitor: {
        title: 'Monitor Station',
        desc: 'This used to be where you would go to get your stats, however you can see those on the right hand side now.',
        actions: [util.leave('Leave the station')]
      },
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
    },
    shops: {
      weapon: {
        title: 'Weapon Shop',
        desc: function ($scope, data) {
          var msg;
          if (this.actions.length === 1) {
            addItemsForSale(this.actions, data.weapon, function (item, confirm) {
              if ($scope.player.weapon && $scope.player.weapon.strength > item.strength) {
                confirmDowngrade(confirm, $scope);
              } else {
                confirm(true);
              }
            }, function (item) {
              $scope.player.weapon = item;
            });
          }
          msg = 'You stroll into the weapon shop to see what is for sale. Choose from the items below.'
          return msg;
        },
        actions: [util.leave('Leave the shop')]
      },
      armor: {
        title: 'Armour Shop',
        desc: function ($scope, data) {
          var msg;
          if (this.actions.length === 1) {
            addItemsForSale(this.actions, data.armor, function (item, confirm) {
              if ($scope.player.armor && $scope.player.armor.strength > item.strength) {
                confirmDowngrade(confirm, $scope);
              } else {
                confirm(true);
              }
            }, function (item) {
              $scope.player.armor = item;
            });
          }
          msg = 'You stroll into the armour shop to see what is for sale. Choose from the items below.';
          return msg;
        },
        actions: [util.leave('Leave the shop')]
      },
      general: {
        title: 'General Store',
        desc: function ($scope, data) {
          var msg;
          if (this.actions.length === 1) {
            addItemsForSale(this.actions, data.items, function (item, confirm) {
              confirm(true);
            }, function (item) {
              if (item.item) {
                $scope.player.items[item.item] += 1; //($scope.player.items[item.item] || 0) + 1;
              } else if (item.id === 'restore') {
                $scope.player.hitPoints = $scope.player.maxHitPoints;
              }
            });
          }
          msg = 'The owner smiles as you walk in. "Can I help you?"';
          return msg;
        },
        actions: [util.leave('Leave the shop')]
      }
    }
  };
});