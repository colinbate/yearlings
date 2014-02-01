define([], function () {
  'use strict';
  var walkObj = function (path, obj) {
    var parts = path.split('.');
    while (parts.length) {
      obj = typeof obj === 'undefined' ? undefined : obj[parts.shift()];
    }
    return obj;
  };

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
    },
    move: function (where, label) {
      return {
        label: label || function (s, data) {
          return walkObj(where, data).title;
        },
        act: function (scope, data) {
          scope.navigateTo(walkObj(where, data));
        }
      }
    },
    visit: function (where, label) {
      return {
        label: label || function (s, data) {
          return walkObj(where, data).title;
        },
        act: function (scope, data) {
          scope.inspect(walkObj(where, data));
        }
      }
    }
  };
});