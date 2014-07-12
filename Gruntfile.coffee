#
# grunt-platforms
# https://github.com/J2AN/grunt-platforms
#
# Copyright (c) 2014 jan4dev
# Licensed under the MIT license.
#
"use strict"
module.exports = (grunt) ->

     # Project configuration.
     grunt.initConfig

          # Before generating any new files, remove any previously-created files.
          clean:
               build: ["build/*/*"]

          platforms:
               root: "build/"
               android:
                    folder: "<%= platforms.root %>/android/"
                    active: false
               ios:
                    folder: "<%= platforms.root %>/ios/"
                    active: false
               web:
                    folder: "<%= platforms.root %>/web/"
                    active: false

          copy:
               android:
                    src: "tests/fixtures/android"
                    dest: "<%=platforms.android.folder%>"
                    expand: true
                    flatten: true

               ios:
                    src: "tests/fixtures/ios"
                    dest: "<%=platforms.ios.folder%>"
                    expand: true
                    flatten: true

               web:
                    src: "tests/fixtures/web"
                    dest: "<%=platforms.web.folder%>"
                    expand: true
                    flatten: true


     # These plugins provide necessary tasks.
     grunt.loadNpmTasks "grunt-contrib-clean"

     # By default, lint and run all tests.
     grunt.registerTask "default", ["clean"]

