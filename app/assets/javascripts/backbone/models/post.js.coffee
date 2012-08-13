class WEB.Models.Post extends Backbone.Model
    
  defaults: ->
    'body': null
    'user_id': WEB.currentUser.id
    'team_id': WEB.currentUser.get('team_id')
    'likes': []
        
  fetchUser: (userId) ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/' + userId
      success: (data) =>
        @set user: data
  
  fetchLikes: (postId) ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/posts/' + postId + '/likes'
      success: (data) =>
        @set likes: data
  
  asJSON: =>
    post = _.clone this.attributes
    return _.extend post, {user: this.get('user'), likes: this.get('likes')}
    
  like: (postId) ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/like?post_id=' + postId + '&user_id=' + WEB.currentUser.id
      
  unlike: (postId) ->
    $.ajax
      type: 'DELETE'
      dataType: 'json'
      url: '/unlike?post_id=' + postId + '&user_id=' + WEB.currentUser.id
  
  addToBucket: (bucketId) ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/bucket/' + bucketId + '/add_post/' + @get('id')
      
  removeFromBucket: (bucketId) ->
    $.ajax
      type: 'DELETE'
      dataType: 'json'
      url: '/bucket/' + bucketId + '/remove_post/' + @get('id')
   
class WEB.Collections.PostsCollection extends Backbone.Collection
  model: WEB.Models.Post