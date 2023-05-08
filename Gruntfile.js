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
      src: {
        options: {
          port: 8059,
          base: 'src',
          keepalive: true
        }
      },
      dist: {
        options: {
          port: 8059,
          base: 'dist',
          keepalive: true
        }
      }
    },
    bowercopy: {
      libs: {
        options: {
          destPrefix: 'src/libs',
          runBower: false
        },
        files: {
          'require.js':  'requirejs/require.js',
          'angular.js':  'angular/angular.js',
          'normalize.css':  'normalize-css/normalize.css',
          'ngDialog.js': 'ngDialog/js/ngDialog.js',
          'ngDialog.css': 'ngDialog/css/ngDialog.css',
          'ngDialog-theme-default.css': 'ngDialog/css/ngDialog-theme-default.css',
          'angularLocalStorage.js': 'angularLocalStorage/src/angularLocalStorage.js',
          'angular-cookies.js': 'angular-cookies/angular-cookies.js'
        }
      }
    },
    requirejs: {
      compile: {
        options: {
          appDir: 'src/',
          baseUrl: 'js',
          removeCombined: true,
          optimizeCss: 'none',
          mainConfigFile: 'src/js/main.js',
          dir: 'build',
          uglify: {
            max_line_length: 200
          },
          modules: [
            // {
            //   name: 'angular',
            //   include: ['ngstorage', 'ngdialog']
            // },
            {
              name: 'main',
              //exclude: ['angular']
            }
          ]
        }
      }
    },
    copy: {
      html: {
        src: 'src/index.html',
        dest: 'dist/index.html'
      },
      icon: {
        src: 'src/favicon.png',
        dest: 'dist/favicon.png'
      },
      css: {
        src: 'src/css/core.css',
        dest: 'dist/css/core.css'
      },
      img: {
        src: 'src/img/load.gif',
        dest: 'dist/img/load.gif'
      },
      js: {
        src: 'build/js/main.js',
        dest: 'dist/js/main.js'
      },
      libs: {
        expand: true,
        cwd: 'build/libs/',
        src: '*.js',
        dest: 'dist/libs/'
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-watch');
  //grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-bowercopy');

  grunt.registerTask('default', ['jshint', 'less:dev']);
  grunt.registerTask('install', ['bowercopy', 'less:clean']);
  grunt.registerTask('play', ['connect:src']);
  grunt.registerTask('pack', ['less:clean', 'requirejs', 'copy']);


};