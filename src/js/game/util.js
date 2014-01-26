define([], function () {
  'use strict';

  return {
    randomInt: function (max, min) {
      return parseInt(Math.floor(Math.random() * (max - min + 1) + min), 10);
    },
    randomFromArray: function (arr) {
      var index;
      if (!arr || arr.length === 0) {
        return;
      };
      index = this.randomInt(arr.length - 1, 0);
      return arr[index];
    },
    leave: function (label) {
      return {
        label: label,
        act : function (scope) {
          scope.finishInspecting();
        }
      }
    }
  };
});