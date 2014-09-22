myApp = angular.module 'MyApp', ['ui.router']

myApp.config ($stateProvider, $urlRouterProvider) ->
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

