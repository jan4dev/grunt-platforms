#
# * grunt-platforms
# * https://github.com/J2AN/grunt-platforms
# *
# * Copyright (c) 2014 jan4dev
# * Licensed under the MIT license.
#
"use strict"
module.exports = (grunt) ->

    hooker = require 'hooker'

    ###
    Receive a task name and if no target specified find active targets and execute the active ones.
    It is assumed that a task has only platform dependent targets.
    If a task has a target per platform plus some others targets, they will be ignored as
    no behavior can be assumed.
    You may enrich this by executing the non-platform dependent targets for each platform target,
    or before them, or after them, etc.

    @return true if task need to be preempted in order to execute platform dependent targets only.
    False else.
    ###
    executeTaskForActiveTargetsOnly = ( task ) ->

        activePlatforms = activeTargets()
        isGlobalBuild = task is "default"

        # If task isn't related to any platform, no preempting
        if !isGlobalBuild && !isPlatformDependent task then return false

        # If a configuration exists for each active platform, preempts the default behavior by executing only
        # these ones
        for platform in activePlatforms
            if isGlobalBuild
                # Executing all tasks for the current platforms
                grunt.task.run platform
            else
                # Getting task and target configuration
                conf = grunt.config.get "#{task}.#{platform}"

                # If we found a configuration for that platform, we use it
                # executing task with correct target
                if conf then grunt.task.run "#{task}:#{platform}"

        # Task is platform dependent so it is preempted
        return true



    ###
    Compute an array of active target names.
    ###
    activeTargets = () ->

        platforms = grunt.config "platforms"

        return [] if !platforms

        result = (platform for platform of platforms when platforms[ platform ].active)

        grunt.verbose.debug JSON.stringify result, null, "    "

        return result



    ###
    Return true if task's configuration is platform dependent.
    ###
    isPlatformDependent = ( task ) ->

        platforms = grunt.config "platforms"
        taskConfiguration = grunt.config task

        if  !taskConfiguration || !platforms || !Object.keys(platforms).length then return false

        for platform of platforms
            if taskConfiguration[ platform ]
                return true

        return false


    ###
    Hook that intercept calls to grunt.task.run so as to execute the task for active platforms only.
    ###
    hooker.hook grunt.task, "run",
        pre: ( task ) ->

            grunt.verbose.debug JSON.stringify task, null, "    "

            # If an alias task, nothing to do
            return if task instanceof Array and task.length

            # If there is already a target specified, no hook
            # specifyng <task>: is also a way to bypass the hook without having a target
            return if task?.match /:/g

            # If task is platform dependent and has active targets : preempt
            if executeTaskForActiveTargetsOnly task
                return hooker.preempt true

    return