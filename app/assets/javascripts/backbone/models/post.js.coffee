class WEB.Models.Post extends Backbone.Model
  
  initialize: ->
    _.bindAll(@)
     
  defaults: ->
    'body': null
    'title': null
    'user_id': WEB.currentUser.id
    'team_id': null
    'likes': []
    'image_id': null
  
  postReady: _.after(4, ->
    @trigger 'postReady'
  )
    
  setup: ->
    @fetchUser()
    @fetchLikes()
    @fetchImage()
    @fetchComments()
    
  fetchUser: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/' + @get('user_id')
      success: (data) =>
        @set user: data
  
  fetchLikes: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/posts/' + @get('id') + '/likes'
      success: (data) =>
        console.log data
        @set likes: data
  
  fetchTeam: (teamId) ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/teams/' + teamId
      success: (data) =>
        @set team: data
  
  fetchImage: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/posts/' + @get('id') + '/image'
      success: (data) =>
        @set image: data
        @postReady()
  
  fetchComments: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/posts/' + @get('id') + '/comments'
      success: (data) =>
        @set comments: data
        @postReady()
  
  asJSON: =>
    post = _.clone this.attributes
    return _.extend post, {user: this.get('user'), likes: this.get('likes'), team: this.get('team'), image: this.get('image'), comments: this.get('comments')}
    
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
  
  sendNewPostEmail: () ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/new_post_mailer/' + @get('id')
   
class WEB.Collections.Posts extends Backbone.Collection
  model: WEB.Models.Post