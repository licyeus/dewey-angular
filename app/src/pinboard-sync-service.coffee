angular.module 'dewey'
.factory 'PinboardSync', ($q, $http) ->
  auth_token = 'licyeus:23619A0AFA3E4AEDC0AE'
  proxy_url = 'https://jsonp.nodejitsu.com/'

  save: (@bookmarks) ->
    bookmarksToSync = _.where @bookmarks, (bookmark) -> bookmark.needsSync
    add_bookmark_url = "https://api.pinboard.in/v1/posts/add?format=json&auth_token=#{auth_token}"

    deferred = $q.defer()
    allPromises = []
    _.each bookmarksToSync, (bookmark) ->
      pinboard_params = {
        url: bookmark.href
        description: bookmark.description
        tags: bookmark.tags
        extended: bookmark.notes
      }
      # TODO: require url and description
      queryParams = []
      _.each pinboard_params, (v, k) ->
        queryParams.push "#{k}=#{encodeURI(v)}" if v
      pinboard_url = "#{add_bookmark_url}&#{queryParams.join('&')}"

      params = { url: pinboard_url }
      allPromises.push $http({ method: 'GET', url: proxy_url, params: params })
    $q.all(allPromises).then (data) ->
      _.each bookmarksToSync, (bookmark) ->
        bookmark.needsSync = false
      deferred.resolve(@bookmarks)
    deferred.promise

  loadBookmarks: (opts = {}) ->
    all_bookmarks_url = "https://api.pinboard.in/v1/posts/all?format=json&auth_token=#{auth_token}"
    recent_bookmarks_url = "https://api.pinboard.in/v1/posts/recent?format=json&auth_token=#{auth_token}"
    pinboard_url = if opts.all then all_bookmarks_url else recent_bookmarks_url

    deferred = $q.defer()
    params = { url: pinboard_url }
    $http({ method: 'GET', url: proxy_url, params: params }).then (response) ->
      deferred.resolve(response.data)
    deferred.promise
