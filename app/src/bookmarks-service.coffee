myApp = angular.module 'MyApp'

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

