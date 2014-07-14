"use strict";

function fileExists(filepath) {
	return grunt.file.exists(grunt.util.normalizelf(filepath))
}

function stringify(object) {
	return JSON.stringify(object, null, "    ")
}

function clone(object) {
	return JSON.parse(JSON.stringify(object))
}

var grunt = require("grunt")
var vows = require("vows")
var assert = require("assert")

// Hack to avoid loading a Gruntfile
grunt.task.init = function () {};

// Grunt configuration
grunt.initConfig({
	clean: {
		build: ["build/*/*"]
	},
	platforms: {
		root: "build/",
		android: {
			folder: "<%= platforms.root %>/android/",
			active: false
		},
		ios: {
			folder: "<%= platforms.root %>/ios/",
			active: false
		},
		web: {
			folder: "<%= platforms.root %>/web/",
			active: false
		}
	},
	copy: {
		android: {
			src: "tests/fixtures/android",
			dest: "<%=platforms.android.folder%>",
			expand: true,
			flatten: true
		},
		ios: {
			src: "tests/fixtures/ios",
			dest: "<%=platforms.ios.folder%>",
			expand: true,
			flatten: true
		},
		web: {
			src: "tests/fixtures/web",
			dest: "<%=platforms.web.folder%>",
			expand: true,
			flatten: true
		}
	}
})

// Load this plugin code
grunt.loadTasks("tasks")

// Load grunt plugins
grunt.loadNpmTasks("grunt-contrib-clean")
grunt.loadNpmTasks("grunt-contrib-copy")

// Declare a vows test suite
var suite = exports.suite = vows.describe("platforms")

suite.addBatch({
	'android only': {
		topic: function () {
			// Activate the android platform
			grunt.config("platforms.android.active", true);
			console.log("platforms: " + (stringify(grunt.config('platforms'))));
			// Launch the copy task
			grunt.tasks(["clean", "copy"], {
				verbose: true
			}, this.callback)
		},
		'should have executed the android target': function () {
			var actual = fileExists('build/android/android')
			assert.equal(actual, true)
		},
		'should NOT have executed the ios target': function () {
			var actual = fileExists('build/ios/ios')
			assert.equal(actual, false)
		},
		'should NOT have executed the web target': function () {
			var actual = fileExists('build/web/web')
			assert.equal(actual, false)
		}
	}
}).addBatch({
	'ios & web but not android': {
		topic: function () {
			// Activate the android platform
			grunt.config("platforms.android.active", false);
			grunt.config("platforms.ios.active", true);
			grunt.config("platforms.web.active", true);
			console.log("platforms: " + (stringify(grunt.config('platforms'))));
			// Launch the copy task
			grunt.tasks(["clean", "copy"], {
				verbose: true
			}, this.callback)
		},
		'should NOT have executed the android target': function () {
			var actual = fileExists('build/android/android')
			assert.equal(actual, false)
		},
		'should have executed the ios target': function () {
			var actual = fileExists('build/ios/ios')
			assert.equal(actual, true)
		},
		'should have executed the web target': function () {
			var actual = fileExists('build/web/web')
			assert.equal(actual, true)
		}
	}
}).addBatch({
	'no-platform': {
		topic: function () {
			grunt.tasks(["clean"], {
				verbose: true
			}, this.callback)
		},
		'after a successful clean': {
			topic: function () {
				// Deactivate all platforms
				grunt.config("platforms.android.active", false);
				grunt.config("platforms.ios.active", false);
				grunt.config("platforms.web.active", false);
				console.log("platforms: " + (stringify(grunt.config('platforms'))));
				// this.callback will never be executed
				grunt.tasks(["copy"], {
					verbose: true,
					debug: true
				}, this.callback)
				// Ugly hack to check the result after some time
				setTimeout(function () {
					this.callback()
				}, 2000)
			},
			'should have executed the android target': function () {
				var actual = fileExists('build/android/android')
				assert.equal(actual, false)
			},
			'should NOT have executed the ios target': function () {
				var actual = fileExists('build/ios/ios')
				assert.equal(actual, false)
			},
			'should NOT have executed the web target': function () {
				var actual = fileExists('build/web/web')
				assert.equal(actual, false)
			}
		}
	}
})