define(['game/util'], function (util) {
  'use strict';

  return {
    title: 'Doomed Woods',
    onArrive: function ($scope, data) {
      if ($scope.player.weapon.last) {
        $scope.doBattle(data.enemy.kamul);
      } else {
        $scope.player.hitPoints = 0;
        $scope.inspect({
          title: 'YOU DIE!',
          desc: 'You step up to the mighty Kamul and realize that you forgot the Dragon\'s Bane. Kamul grins wickedly then throws you into a tree. You are laying there helplessly when you start screaming! Kamul is using a heat spell to melt your legs! You are unable to lapse into unconsciousness as Kamul is controlling your mind. Your bloodcurdling screams are lost in the forest. You are staring at your bones as the flesh has already bubbled off your legs and is starting at your arms. Just then Kamul knocks over a tree and a large branch is thrust through you stomach. You slowly die in the most painful death possible as your gastric acids leak into your bloodstream and corrode your organs',
          actions: []
        });
      }
    },
    onFinishFighting: function ($scope, d, $q) {
      $scope.inspect({
          title: 'YOU WIN!',
          desc: 'You strike the fatal blow to Kamul. He drops to the ground hissing and gurgling. You are the hero of the town! CONGRATULATIONS!!!!!!! You have beaten Yearlings!',
          actions: []
        });
    },
    actions: []
  };
});