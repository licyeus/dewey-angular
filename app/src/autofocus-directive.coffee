angular.module 'dewey'
.directive 'autofocus', ($timeout) ->
  {
    restrict: 'A'
    link: (scope, element, attrs) ->
      $timeout -> element[0].focus()
  }

