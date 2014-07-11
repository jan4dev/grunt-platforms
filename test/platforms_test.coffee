"use strict"
grunt = require("grunt")

# Actually load this plugin's task(s).
grunt.loadTasks "tasks"

# Backup of the original config
platforms = grunt.config 'platforms'

#
#  ======== A Handy Little Nodeunit Reference ========
#  https://github.com/caolan/nodeunit
#
#  Test methods:
#    test.expect(numAssertions)
#    test.done()
#  Test assertions:
#    test.ok(value, [message])
#    test.equal(actual, expected, [message])
#    test.notEqual(actual, expected, [message])
#    test.deepEqual(actual, expected, [message])
#    test.notDeepEqual(actual, expected, [message])
#    test.strictEqual(actual, expected, [message])
#    test.notStrictEqual(actual, expected, [message])
#    test.throws(block, [error], [message])
#    test.doesNotThrow(block, [error], [message])
#    test.ifError(value)
#

fileExists = (filepath) ->
  return grunt.file.exists grunt.util.normalizelf filepath

stringify = (object)->
  return JSON.stringify object, null, "    "


###
Tests
###
exports.platforms =

  # Before each test
  setUp: (done) ->
    done()

  # After each test
  tearDown: (done) ->
    grunt.config 'platforms', platforms
    done()

  # Android only
  android: (test) ->

    test.expect 1

    grunt.config "platforms.android.active", true
    console.log "platforms: #{stringify grunt.config 'platforms'}"

    # grunt.task.run "copy"
    # actual = fileExists 'build/android/android'
    # test.equal actual, true, 'copy:android target should have been called'

    test.done()



