/* global module:false */
module.exports = function(grunt) {
  'use strict';
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    meta: {
      banner:
        '/*!\n' +
        ' * Yearlings <%= pkg.version %> (<%= grunt.template.today("yyyy-mm-dd, HH:MM") %>)\n' +
        ' * https://bitbucket.org/colinbate/yearlings\n' +
        ' * MIT licensed\n' +
        ' *\n' +
        ' * Copyright (C) 2014 Colin Bate\n' +
        ' */\n'
    },
    jshint: {
      options: {
        bitwise: true,
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        nonew: true,
        plusplus: true,
        quotmark: true,
        sub: true,
        strict: true,
        undef: true,
        unused: true,
        trailing: true,
        eqnull: true,
        browser: true,
        expr: true,
        globals: {
          define: false,
          require: false,
          module: false
        }
      },
      files: ['src/js/**/*.js']
    },
    less: {
      dev: {
        options: {
          dumpLineNumbers: 'mediaquery'
        },
        files: {
          'src/css/core.css': 'src/less/core.less'
        }
      },
      clean: {
        files: {
          'src/css/core.css': 'src/less/core.less'
        }
      }
    },
    watch: {
      less: {
        files: ['src/less/**/*.less'],
        tasks: ['less:dev']
      },
      js: {
        files: ['src/js/**/*.js'],
        tasks: ['jshint']
      }
    },
    connect: {
      server: {
        options: {
          port: 8059,
          base: 'src',
          keepalive: true
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-less');
  //grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-watch');
  //grunt.loadNpmTasks('grunt-contrib-clean');
  //grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-connect');
  //grunt.loadNpmTasks('grunt-rsync');

  grunt.registerTask('default', ['jshint', 'less:dev']);


};