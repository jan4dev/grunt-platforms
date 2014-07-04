/*
 * grunt-platforms
 * https://github.com/J2AN/grunt-platforms
 *
 * Copyright (c) 2014 jan4dev
 * Licensed under the MIT license.
 */

'use strict';

module.exports = function ( grunt ) {

  // Please see the Grunt documentation for more information regarding task
  // creation: http://gruntjs.com/creating-tasks

  grunt.registerMultiTask( 'platforms', 'Allows selective build by defining a list of platforms', function () {

    // Merge task-specific and/or target-specific options with these defaults.
    var options = this.options( {
      punctuation: '.',
      separator: ', '
    } );



  } );

};