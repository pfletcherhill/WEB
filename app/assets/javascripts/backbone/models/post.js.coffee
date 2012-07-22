class WEB.Models.Post extends Backbone.Model
    
  defaults: ->
    'body': null
    'user_id': WEB.currentUser.id
    'team_id': WEB.currentUser.get('team_id')
    'likes': []
  
  fetchAttributes: (userId, postId) ->
    console.log 'fetchAttributes'
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/' + userId
      success: (data) =>
        console.log 'fetchUser done'
        @set user: data
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/posts/' + postId + '/likes'
      success: (data) =>
        console.log 'fetchLikes done'
        @set likes: data
        
  fetchUser: (userId) ->
    console.log 'fetchAttributes'
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/' + userId
      success: (data) =>
        console.log 'fetchUser done'
        @set user: data
  
  fetchLikes: (postId) ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/posts/' + postId + '/likes'
      success: (data) =>
        console.log 'fetchLikes done'
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
      type: 'PUT'
      dataType: 'json'
      url: '/unlike?post_id=' + postId + '&user_id=' + WEB.currentUser.id
    
class WEB.Collections.PostsCollection extends Backbone.Collection
  model: WEB.Models.Post