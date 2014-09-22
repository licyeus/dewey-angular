class AddController
  constructor: (@$state, @$timeout, @BookmarkService) ->

  saveBookmark: (bookmark) ->
    @BookmarkService.save(bookmark).then =>
      @$state.go 'results' # TODO: dismiss popup

  checkIfExists: (href) ->
    @BookmarkService.loadIfExists(href).then (bookmark) =>
      @bookmark = bookmark if bookmark
