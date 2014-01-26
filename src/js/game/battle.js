define([], function () {
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
  };

  return {
    encounter: function (enemy, $scope, $q) {
      var deferred = $q.defer(),
          prompt = wantToFight(enemy);
      prompt.actions = [
        {
          label: 'Fight!',
          act: function () {
            deferred.resolve();
            // TODO: Start fighting
            $scope.currentBattle = {};
            $scope.finishInspecting();
          }
        },
        {
          label: 'Best avoid it...',
          act: function () {
            deferred.reject();
            $scope.finishInspecting();
          }
        }
      ];
      $scope.inspect(prompt);
      return deferred.promise;
    }
  };
});