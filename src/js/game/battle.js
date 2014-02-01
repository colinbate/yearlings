define(['game/util'], function (util) {
  'use strict';
  var wantToFight = function (enemy) {
    var title = 'Encountered ',
        pronoun = 'He';
    if (!enemy.boss) {
      title += 'a ';
      pronoun = 'It ';
    }
    title += enemy.name;
    return {
      title: title,
      desc: pronoun + ' has not noticed you yet, do you want to fight?'
    };
  },
  inflictDamage = function ($scope, amount) {
    $scope.currentBattle.hitPoints -= amount;
    if ($scope.currentBattle.hitPoints < 0) {
      $scope.currentBattle.hitPoints = 0;
    }
    $scope.currentBattle.desc = 'You attacked with ' + amount;
    return $scope.currentBattle.hitPoints;
  },
  receiveDamage = function ($scope, enemyMax) {
    var bite = util.randomInt(enemyMax + 2, 0),
        block = $scope.player.defence + ($scope.player.armor.strength || 0);
    bite -= (block / 2);
    bite = Math.max(Math.floor(bite), 0);
    $scope.player.hitPoints -= bite;
    $scope.player.hitPoints = Math.max($scope.player.hitPoints, 1);
    $scope.currentBattle.desc += ', and you were hit with ' + bite;
    return $scope.player.hitPoints;
  };

  return {
    encounter: function (enemy, $scope, $q) {
      var deferred = $q.defer(),
          prompt;
      if (enemy.boss) {
        deferred.resolve(enemy);
        return deferred.promise;
      }
      prompt = wantToFight(enemy);
      prompt.actions = [
        {
          label: 'Fight!',
          act: function () {
            deferred.resolve(enemy);
            // TODO: Start fighting
            $scope.finishInspecting();
          }
        },
        {
          label: 'Best avoid it...',
          act: function () {
            deferred.reject(enemy);
            $scope.finishInspecting();
          }
        }
      ];
      $scope.inspect(prompt);
      return deferred.promise;
    },
    startFight: function (enemy, $scope, $q) {
      var deferred = $q.defer(),
          evalAttack,
          attack = {
            label: 'Attack',
            act: function (scope) {
              var upper = (scope.player.attack + (scope.player.weapon.strength || 0)) * 2 + 2,
                  take = util.randomInt(upper, 0);
              if (enemy.boss) {
                take = Math.ceil(take * 2 / 3);
              }
              evalAttack(take);
            }
          },
          bomb = {
            label: 'Use bomb',
            act: function (scope) {
              evalAttack(20);
              scope.player.items.bomb -= 1;
            }
          },
          cure = {
            label: 'Use cure potion',
            act: function (scope) {
              scope.player.hitPoints += 10;
              scope.player.hitPoints = Math.min(scope.player.hitPoints, scope.player.maxHitPoints);
              scope.player.items.cure -= 1;
              scope.currentBattle.desc = 'You drink a cure potion, your health is now ' + scope.player.hitPoints;
            }
          },
          run = {
            label: 'Run!',
            act: function (scope) {
              var roll = util.randomInt(10, 1);
              if (roll >= 7 && !scope.currentBattle.noRunning) {
                // Can run
                scope.currentBattle.desc = 'You were able to run away!';
                waitContinue();
              } else {
                // Can't run
                scope.currentBattle.noRunning = true;
                scope.currentBattle.desc = 'You were not able to run away';
              }
            }
          },
          finish = {
            label: 'Continue...',
            act: function (scope) {
              deferred.resolve();
              scope.currentBattle = {};
            }
          },
          setupActions = function () {
            $scope.currentBattle.actions = [attack];
            if ($scope.player.items.bombs && !enemy.noBombs) {
              $scope.currentBattle.actions.push(bomb);
            }
            if ($scope.player.items.cure) {
              $scope.currentBattle.actions.push(cure);
            }
            $scope.currentBattle.actions.push(run);
          },
          waitContinue = function () {
            $scope.currentBattle.actions = [];
            $scope.currentBattle.actions.push(finish);
          };
      evalAttack = function (amount) {
        var enemyRemaining, youRemaining;
        enemyRemaining = inflictDamage($scope, amount);
        if (enemyRemaining === 0) {
          $scope.currentBattle.desc += ', and were victorious!';
          if (enemy.victory) {
            $scope.currentBattle.desc += ' ' + enemy.victory;
          }
          if (enemy.item) {
            if (enemy.item.weapon) {
              $scope.player.items.weapon = $scope.player.weapon;
              $scope.player.weapon = enemy.item.weapon;
            }
          }
          $scope.player.experience += enemy.experience;
          $scope.player.money += enemy.money;
          $scope.levelUp();
          waitContinue();
        } else {
          youRemaining = receiveDamage($scope, enemy.hitPoints);
          if (youRemaining === 0) {
            deferred.reject();
          } else {
            setupActions();
          }
        }
      };
      $scope.currentBattle = {
        name: enemy.name,
        desc: 'How would you like to proceed with the fight?',
        hitPoints: enemy.hitPoints,
        maxHitPoints: enemy.hitPoints,
        actions: [],
        enemy: enemy
      };
      setupActions();
      return deferred.promise;
    }
  };
});