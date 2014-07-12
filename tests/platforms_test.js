"use strict";
var assert, clone, fileExists, grunt, stringify, suite, vows;

fileExists = function (filepath) {
	return grunt.file.exists(grunt.util.normalizelf(filepath));
};

stringify = function (object) {
	return JSON.stringify(object, null, "    ");
};

clone = function (object) {
	return JSON.parse(JSON.stringify(object));
};

grunt = require("grunt");
vows = require("vows");
assert = require("assert");

grunt.loadNpmTasks("grunt-contrib-copy");

// Actually load this plugin's task(s).
grunt.loadTasks("tasks")

exports.suite = suite = vows.describe("platforms");

suite.addBatch({
	'android': {
		topic: function () {
			grunt.config("platforms.android.active", true);
			console.log("platforms: " + (stringify(grunt.config('platforms'))));
			// grunt.util.spawn({
			// 	cmd: "grunt",
			// 	args: ["copy", "-vd"],
			// 	opts: {
			// 		stdio: 'inherit'
			// 	}
			// }, this.callback);
			grunt.tasks(["clean", "copy"], {}, this.callback)
		},
		'should have executed the android target': function (error, result, code) {
			console.log("Grunt code: " + code);
			var actual = fileExists('build/android/android');
			assert.equal(actual, true);
		},
		'should NOT have executed the ios target': function (error, result, code) {
			var actual = fileExists('build/ios/ios');
			assert.equal(actual, false);
		},
		'should NOT have executed the web target': function (error, result, code) {
			var actual = fileExists('build/web/web');
			assert.equal(actual, false);
		}
	}
});