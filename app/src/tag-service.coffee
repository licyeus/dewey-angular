angular.module 'dewey'
.factory 'TagService', ($q, $http, PinboardSync) ->
  getTags: ->
    deferred = $q.defer()
    $http.get('data/tags.json').then (response) ->
      deferred.resolve(Object.keys(response.data))
    deferred.promise
