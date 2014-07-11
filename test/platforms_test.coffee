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

"use strict"

# Utility functions
fileExists = (filepath) ->
  return grunt.file.exists grunt.util.normalizelf filepath

stringify = (object)->
  return JSON.stringify object, null, "    "

clone = (object) ->
  return JSON.parse JSON.stringify object


# Node dependencies
grunt = require("grunt")

# Backup of the original config
config = grunt.config()


# Tests
exports.platforms =

  # Before each test
  setUp: (done) ->
    done()

  # After each test
  tearDown: (done) ->
    grunt.config 'platforms', config.platforms
    done()

  # Android only
  android: (test) ->

    # config = clone config
    grunt.config "platforms.android.active", true
    console.log "platforms: #{stringify grunt.config 'platforms'}"

    doneFn = (error, result, code) ->
      test.expect 3
      console.log "code: #{code}"
      # android target
      actual = fileExists 'build/android/android'
      test.equal actual, true, 'copy:android target should have been called'
      # ios target
      actual = fileExists 'build/ios/ios'
      test.equal actual, false, 'copy:ios target should NOT have been called'
      # web target
      actual = fileExists 'build/web/web'
      test.equal actual, false, 'copy:web target should NOT have been called'
      # done
      test.done()

    grunt.util.spawn
      grunt: true
      args: ["copy"]
      opts:
        stdio: 'inherit'
    , doneFn



