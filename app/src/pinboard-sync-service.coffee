angular.module 'MyApp'
.factory 'PinboardSync', ($q, $http) ->
  save: (@bookmarks) ->
    bookmarksToSync = _.where @bookmarks, (bookmark) -> bookmark.needsSync

    deferred = $q.defer()
    deferred.resolve() # TODO: perform sync
    deferred.promise

  loadBookmarks: ->
    deferred = $q.defer()
    $http.get('data/bookmarks.json').then (response) ->
      deferred.resolve(response.data)
    deferred.promise
