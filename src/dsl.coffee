'use strict'

{isObject} = require 'underscore'
{ResponseSpecification} = require './responder'

class Dsl
  constructor: (@_addResponseSpecification, [requestInfo]) ->
    @_withMode = 'replaceContent'

    if isObject requestInfo
      @_path = requestInfo.path
      @_query = requestInfo.query
    else
      @_path = requestInfo
      @_query = {}

  byReplacing: (key) ->
    @_withMode = 'replaceKey'
    @_key = key
    this

  with: (what) ->
    if isObject what
      body = what.body
      statusCode = what.statusCode || 200
      method = what.method || 'GET'
    else
      body = what
      statusCode = 200
      method = 'GET'

    spec = switch @_withMode
      when 'replaceContent'
        path: @_path
        method: method
        query: @_query
        body: body
        statusCode: statusCode
      when 'replaceKey'
        path: @_path
        method: method
        query: @_query
        replaceKey: @_key
        replaceValue: what
    @_addResponseSpecification spec

module.exports = Dsl
