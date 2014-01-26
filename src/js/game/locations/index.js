define([
  'game/locations/town',
  'game/locations/grass',
  'game/locations/rocky',
  ], function (town, grass, rocky) {
  'use strict';

  return {
    town: town,
    monitor: {
      title: 'Monitor Station',
      desc: 'This used to be where you would go to get your stats, however you can see those on the right hand side now.',
      actions: [
        { label: 'Leave station', act: function ($scope) { $scope.finishInspecting(); } }
      ]
    },
    grassland: grass,
    rockyland: rocky
  };
});