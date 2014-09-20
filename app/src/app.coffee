myApp = angular.module 'MyApp', []

class SearchController
  constructor: (BookmarkService) ->
    BookmarkService.all().then (bookmarks) =>
      @bookmarks = bookmarks

  tagClick: (tag) ->
    console.log 'clicked tag', tag

myApp.controller 'SearchController', ['BookmarkService', SearchController]

myApp.filter 'reverse', ->
  (items) ->
    items.slice().reverse() if angular.isArray(items)

myApp.factory 'BookmarkService', ($q, $http) ->
  all: ->
    deferred = $q.defer()
    $http.get('data/bookmarks.json').then (response) ->
      deferred.resolve(response.data)
    deferred.promise
