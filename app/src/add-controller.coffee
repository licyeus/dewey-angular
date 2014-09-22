class AddController
  constructor: (@$state, @$timeout, @BookmarkService) ->
    href = 'http://www.jbox.dk/quotations.htm' # TODO: this should come in from invocation
    @BookmarkService.loadIfExists(href).then (bookmark) =>
      @bookmark = bookmark

  saveBookmark: (bookmark) ->
    @BookmarkService.save(bookmark).then =>
      @$state.go 'results' # TODO: dismiss popup

