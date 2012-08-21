class WEB.Models.Bucket extends Backbone.Model
  
  paramRoot: 'bucket'
  
  urlRoot: "/buckets"
    
  defaults: ->
    'name': null
    'user_id': WEB.currentUser.id
    'team_id': WEB.currentUser.get('team_id')
        
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
        
  addPost: (id, postId) ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/bucket/' + id + '/add_post/' + postId
      
  asJSON: =>
    post = _.clone this.attributes
    return _.extend post, {user: this.get('user'), posts: this.get('posts')}
    
class WEB.Collections.Buckets extends Backbone.Collection
  model: WEB.Models.Bucket