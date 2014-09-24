angular.module 'dewey', ['ui.router']
.config ($stateProvider, $urlRouterProvider) ->
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
.run ($state) ->
  Mousetrap.bind 'command+1', -> $state.go 'add'
  Mousetrap.bind 'command+2', -> $state.go 'results'

