myApp = angular.module 'MyApp', []

class SearchController
  constructor: (BookmarkService) ->
    BookmarkService.all().then (bookmarks) =>
      @bookmarks = bookmarks

  tagClick: (tag) ->
    @query ||= ''
    @query += " ##{tag}"

myApp.controller 'SearchController', ['BookmarkService', SearchController]

myApp.factory 'BookmarkService', ($q, $http) ->
  all: ->
    deferred = $q.defer()
    $http.get('data/bookmarks.json').then (response) ->
      deferred.resolve(response.data)
    deferred.promise

class Searcher
  constructor: (@queryRegex) ->

  parse: (searchQuery = '') ->
    matches = searchQuery.match(@queryRegex)

myApp.filter 'search', ->
  QUERY_REGEX = /(.*)#(.*)/
  searcher = new Searcher(QUERY_REGEX)

  (items, searchQuery) =>
    items

myApp.filter 'reverse', ->
  (items) ->
    items.slice().reverse() if angular.isArray(items)

