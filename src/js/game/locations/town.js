define(['game/util'], function (util) {
  'use strict';
  var tellerMessages = [
    'Enemies in the grassy field are easier than those in the rocky land.',
    'I can\'t find my magical pendant, I think I lost it somewhere in the field.',
    'The evil dragon Kamul lurks in the Doomed Woods.'
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
          } else if ($scope.player.weapon.last) {
            if ($scope.player.level < 13) {
              msg = 'Excellent you found the legendary sword! If I were you, I\'d get to level 13 before even thinking about going into the Doomed Woods.';
            } else {
              msg = 'Now that you have the Dragon\'s Bane and are strong enough, you are unstoppable! GO - KILL KAMUL!!';
            }
          } else if ($scope.player.state.returnedPendant) {
            if (!$scope.player.items.rope) {
              msg = 'The general store stocks more than they sell.';
            } else {
              msg = 'Go! Find the sword and defeat the evil dragon Kamul!';
            }
          } else {
            msg = util.randomFromArray(tellerMessages);
          }
          return '"' + msg + '"';
        },
        actions: [util.leave('Leave the tent')],
        onUninspect: function ($scope) {
          if ($scope.player.items.pendant) {
            delete $scope.player.items['pendant'];
            $scope.player.state.returnedPendant = true;
          }
        }
      }
    },
    shops: {
      weapon: {
        title: 'Weapon Shop',
        baseDesc: 'You stroll into the weapon shop to see what is for sale. Choose from the items below.',
        actions: [util.leave('Leave the shop')],
        onInspect: function ($scope, data) {
          var self = this;
          self.desc = self.baseDesc;
          if (this.actions.length === 1) {
            addItemsForSale(this.actions, data.weapon, function (item, confirm) {
              if ($scope.player.weapon && $scope.player.weapon.strength > item.strength) {
                $scope.inspect(confirmDowngrade(confirm, $scope));
              } else {
                confirm(true);
              }
            }, function (item) {
              var prefix = 'You bought a ' + item.name + ' ';
              if ($scope.player.weapon.price) {
                prefix += 'and you sold your ' + $scope.player.weapon.name + ' for ' + Math.floor($scope.player.weapon.price / 2) + '. ';
                $scope.credit(Math.floor($scope.player.weapon.price / 2));
              }
              $scope.player.weapon = item;
              self.desc = prefix;
            });
          }
        }
      },
      armor: {
        title: 'Armour Shop',
        baseDesc: 'You stroll into the armour shop to see what is for sale. Choose from the items below.',
        actions: [util.leave('Leave the shop')],
        onInspect: function ($scope, data) {
          var self = this;
          self.desc = self.baseDesc;
          if (this.actions.length === 1) {
            addItemsForSale(this.actions, data.armor, function (item, confirm) {
              if ($scope.player.armor && $scope.player.armor.strength > item.strength) {
                $scope.inspect(confirmDowngrade(confirm, $scope));
              } else {
                confirm(true);
              }
            }, function (item) {
              var prefix = 'You bought a ' + item.name + ' ';
              if ($scope.player.armor.price) {
                prefix += 'and you sold your ' + $scope.player.armor.name + ' for ' + Math.floor($scope.player.armor.price / 2) + '. ';
                $scope.credit(Math.floor($scope.player.armor.price / 2));
              }
              $scope.player.armor = item;
              self.desc = prefix + self.baseDesc;
            });
          }
        }
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
              } else if (item.id === 'save') {
                $scope.loadDialog(true);
              }
            });
          }
          msg = 'The owner smiles as you walk in. "Can I help you?"';
          if ($scope.player.items.rope === 1) {
            msg = 'As you walk into the item shop the man behind the counter sees your rope and asks what it\'s for. After telling him he laughs and says "Why that old rope wouldn\'t \'old nobody. You\'se lucky dat I got me a new rope here, \'ave it!" You take the rope from the man.';
          }
          return msg;
        },
        actions: [util.leave('Leave the shop')],
        onUninspect: function ($scope) {
          if ($scope.player.items.rope === 1) {
            $scope.player.items.rope = 2;
          }
        }
      }
    }
  };
});