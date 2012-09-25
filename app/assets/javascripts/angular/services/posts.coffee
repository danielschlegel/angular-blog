angular.service 'PostsService', ($resource) ->
  $resource(
    'posts/:posts_id',
    {},
    {
      'update': {
          method: 'PUT'
        }
    }
  )
