define([
  'game/locations/town',
  'game/locations/grass',
  'game/locations/rocky',
  'game/locations/forest',
  ], function (town, grass, rocky, forest) {
  'use strict';

  return {
    town: town,
    grassland: grass,
    rockyland: rocky,
    forest: forest
  };
});