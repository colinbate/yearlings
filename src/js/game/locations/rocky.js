define([], function () {
  'use strict';

  return {
    title: 'Rocky land',
    desc: 'A large barren scrubland, this area has a rough edge to it. Be careful to mind your step here. The field and town are not too far.',
    actions: [
      {
        label: 'Explore rocky area',
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
        label: 'Explore field',
        act: function ($scope, data) {
          $scope.navigateTo(data.locations.grassland);
        }
      }
    ]
  };
});