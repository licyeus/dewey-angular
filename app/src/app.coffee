myApp = angular.module 'MyApp', []

class SearchController
  constructor: ($scope, $timeout, BookmarkService) ->
    QUERY_REGEX = /(#\w*)/g
    @searcher = new Searcher(QUERY_REGEX)
    @query ||= ''

    BookmarkService.all().then (bookmarks) =>
      @bookmarks = _.map bookmarks, (bookmark) ->
        bookmark.searchable = bookmark.description.toLowerCase()
        bookmark.tags = bookmark.tags.split(' ')
        bookmark
      @filteredBookmarks = bookmarks.reverse()

    debounced = null
    $scope.$watch 'search.query', (newVal) =>
      $timeout.cancel(debounced)
      debounced = $timeout =>
        parsedSearchQuery = @searcher.parse(newVal)
        @filteredBookmarks = @searcher.search(@bookmarks, parsedSearchQuery).reverse() if @bookmarks
      , 200

  tagClick: (tag) ->
    @query = [@query, "##{tag}"].join(' ').trim()

myApp.controller 'SearchController', ['$scope', '$timeout', 'BookmarkService', SearchController]

myApp.factory 'BookmarkService', ($q, $http) ->
  all: ->
    deferred = $q.defer()
    $http.get('data/bookmarks.json').then (response) ->
      deferred.resolve(response.data)
    deferred.promise

class Searcher
  constructor: (@queryRegex) ->

  parse: (searchQuery = '') ->
    searchText = searchQuery.replace(@queryRegex, '').trim()
    hashtags = _.map searchQuery.match(@queryRegex), (match) -> match.slice(1)
    {
      text: searchText
      hashtags: hashtags
    }

  search: (bookmarks, search) ->
    _.chain bookmarks
      .filter (bookmark) ->
        bookmark.searchable.indexOf(search.text) != -1
      .filter (bookmark) ->
        # TODO: match partial hashtags, eg, #to_ should match both #to_read and #to_watch
        search.hashtags.length == 0 || _.intersection(bookmark.tags, search.hashtags).length == search.hashtags.length
      .value()
