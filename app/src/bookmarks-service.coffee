angular.module 'dewey'
.factory 'BookmarkService', ($q, PinboardSync) ->
  loadBookmarksFromStore = ->
    deferred = $q.defer()
    b = store.get('bookmarks')
    if b && Array.isArray(b)
      deferred.resolve(b)
    else
      PinboardSync.loadBookmarks().then (b) =>
        # TODO: index/sort bookmarks for faster searches
        store.set('bookmarks', b.reverse())
        deferred.resolve(store.get('bookmarks'))
    deferred.promise

  getBookmarks: ->
    deferred = $q.defer()
    if @bookmarks && @bookmarks.length > 0
      deferred.resolve(@bookmarks)
    else
      loadBookmarksFromStore().then (data) =>
        @bookmarks = data
        deferred.resolve(@bookmarks)
    deferred.promise

  save: (bookmark) ->
    bookmark.needsSync = true
    # TODO: better validation of bookmark schema
    bookmark.tags = bookmark.tags || ''

    existing = _.find @bookmarks, (b) -> b.href == bookmark.href
    index = _.indexOf(@bookmarks, existing) # TODO: combine this with above line for performance

    if index != -1
      @bookmarks[index] = bookmark
    else
      @bookmarks.push(bookmark)

    store.set('bookmarks', @bookmarks)
    PinboardSync.save(@bookmarks)

    deferred = $q.defer()
    deferred.resolve(bookmark)
    deferred.promise

  loadIfExists: (href) ->
    deferred = $q.defer()
    @getBookmarks().then (bookmarks) ->
      found = _.find bookmarks, (bookmark) -> bookmark.href == href
      deferred.resolve(angular.copy(found))
    return deferred.promise

