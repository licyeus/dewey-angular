myApp = angular.module 'MyApp', []

class SearchController
  constructor: ($scope, $http) ->
    $http.get('data/bookmarks.json').then (response) =>
      @bookmarks = response.data

  tagClick: (tag) ->
    console.log 'clicked tag', tag

myApp.controller 'SearchController', ['$scope', '$http', SearchController]

myApp.filter 'reverse', ->
  (items) ->
    items.slice().reverse() if angular.isArray(items)
