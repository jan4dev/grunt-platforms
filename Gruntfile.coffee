#
# * grunt-platforms
# * https://github.com/J2AN/grunt-platforms
# *
# * Copyright (c) 2014 jan4dev
# * Licensed under the MIT license.
#
"use strict"
module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig

    # Definition of available targets.
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

    # Before generating any new files, remove any previously-created files.
    clean:
      build: ["build/*/*"]

    # Copy task configuration
    copy:
      android:
        src: "test/fixtures/android"
        dest: "<%=platforms.android.folder%>"
        expand: true
        flatten: true
      ios:
        src: "test/fixtures/ios"
        dest: "<%=platforms.ios.folder%>"
        expand: true
        flatten: true
      web:
        src: "test/fixtures/web"
        dest: "<%=platforms.web.folder%>"
        expand: true
        flatten: true

    # Unit tests.
    nodeunit:
      tests: ["test/*_test.coffee"]

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-nodeunit"

  # Actually load this plugin's task(s).
  grunt.loadTasks "tasks"

  # Whenever the "test" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", ["clean", "nodeunit"]

  # By default, lint and run all tests.
  grunt.registerTask "default", ["test"]

