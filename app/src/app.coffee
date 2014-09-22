myApp = angular.module 'MyApp', ['ui.router']

myApp.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise 'add'

  $stateProvider
    .state 'add', {
      url: '/add'
      templateUrl: 'add.html'
      controller: 'AddController as add'
    }
    .state 'results', {
      url: '/results'
      templateUrl: 'results.html'
      controller: 'ResultsController as results'
    }

class ResultsController
  constructor: ($scope, $timeout, BookmarkService) ->
    QUERY_REGEX = /(#\w*)/g
    @searcher = new Searcher(QUERY_REGEX)
    @query ||= ''

    BookmarkService.getBookmarks().then (bookmarks) =>
      @bookmarks = _.map bookmarks, (bookmark) ->
        bookmark.searchable = bookmark.description.toLowerCase()
        bookmark.tagsArray = bookmark.tags.split(' ')
        bookmark
      @filteredBookmarks = bookmarks.reverse()

    debounced = null
    $scope.$watch 'results.query', (newVal) =>
      $timeout.cancel(debounced)
      debounced = $timeout =>
        parsedSearchQuery = @searcher.parse(newVal)
        @filteredBookmarks = @searcher.search(@bookmarks, parsedSearchQuery).reverse() if @bookmarks
      , 200

  tagClick: (tag) ->
    @query = [@query, "##{tag}"].join(' ').trim()

class AddController
  constructor: (@$state, @$timeout, @BookmarkService) ->
    href = 'http://www.jbox.dk/quotations.htm' # TODO: this should come in from invocation
    @BookmarkService.loadIfExists(href).then (bookmark) =>
      @bookmark = bookmark

  saveBookmark: (bookmark) ->
    @BookmarkService.save(bookmark).then =>
      @$state.go 'results' # TODO: dismiss popup

myApp.factory 'BookmarkService', ($q, $http) ->
  getBookmarks: ->
    deferred = $q.defer()
    if @bookmarks
      deferred.resolve(@bookmarks)
    else
      $http.get('data/bookmarks.json').then (response) =>
        # TODO: index/sort bookmarks for faster searches
        @bookmarks = response.data || []
        deferred.resolve(@bookmarks)
    deferred.promise

  save: (bookmark) ->
    deferred = $q.defer()
    # TODO: persist bookmark
    existing = _.find @bookmarks, (b) -> b.href == bookmark.href
    index = _.indexOf(@bookmarks, existing) # TODO: combine this with above line for performance
    if index != -1
      @bookmarks[index] = bookmark
    else
      @bookmarks.push(bookmark)
    deferred.resolve(bookmark)
    deferred.promise

  loadIfExists: (href) ->
    deferred = $q.defer()
    @getBookmarks().then (bookmarks) ->
      found = _.find bookmarks, (bookmark) -> bookmark.href == href
      deferred.resolve(angular.copy(found))
    return deferred.promise

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
        search.hashtags.length == 0 || _.intersection(bookmark.tagsArray, search.hashtags).length == search.hashtags.length
      .value()
