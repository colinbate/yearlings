define([
  'game/locations/town',
  'game/locations/grass',
  'game/locations/rocky',
  ], function (town, grass, rocky) {
  'use strict';

  return {
    town: town,
    grassland: grass,
    rockyland: rocky
  };
});