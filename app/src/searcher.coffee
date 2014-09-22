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

