class WEB.Models.Bucket extends Backbone.Model
    
  defaults: ->
    'name': null
    'user_id': WEB.currentUser.id
    'team_id': WEB.currentUser.get('team_id')
    'posts': []
        
  fetchUser: (userId) ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/' + userId
      success: (data) =>
        @set user: data
  
  fetchPosts: (bucketId) ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/bucket/' + bucketId + '/posts'
      success: (data) =>
        @set posts: data
  
  asJSON: =>
    post = _.clone this.attributes
    return _.extend post, {user: this.get('user'), posts: this.get('posts')}
    
class WEB.Collections.BucketsCollection extends Backbone.Collection
  model: WEB.Models.Bucket