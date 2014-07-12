"use strict";

function fileExists(filepath) {
	return grunt.file.exists(grunt.util.normalizelf(filepath));
};

function stringify(object) {
	return JSON.stringify(object, null, "    ");
};

function clone(object) {
	return JSON.parse(JSON.stringify(object));
};

var grunt = require("grunt");
var vows = require("vows");
var assert = require("assert");

var suite = exports.suite = vows.describe("platforms");

suite.addBatch({
	'android': {
		topic: function () {
			// grunt.config("platforms.android.active", true);
			// console.log("platforms: " + (stringify(grunt.config('platforms'))));
			// console.log("config: " + (stringify(grunt.config())));
			grunt.tasks(["clean", "copy"], {
				// verbose: true
			}, this.callback)
		},
		'should have executed the android target': function () {
			var actual = fileExists('build/android/android');
			assert.equal(actual, true);
		},
		'should NOT have executed the ios target': function () {
			var actual = fileExists('build/ios/ios');
			assert.equal(actual, false);
		},
		'should NOT have executed the web target': function () {
			var actual = fileExists('build/web/web');
			assert.equal(actual, false);
		}
	}
});