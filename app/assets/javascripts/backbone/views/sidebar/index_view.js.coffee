WEB.Views.Sidebar ||= {}

class WEB.Views.Sidebar.IndexView extends Backbone.View
  commentsContainer: JST["backbone/templates/sidebar/comments"]
  userTemplate: JST["backbone/templates/sidebar/user"]
  commentTemplate: JST["backbone/templates/comments/comment"]
  postTemplate: JST["backbone/templates/comments/post"]
  form: JST["backbone/templates/comments/form"]
  photobox: JST["backbone/templates/posts/photobox"]

  el: 'body'
  
  initialize: () ->
    _.bindAll(@) 
    @comments = new WEB.Collections.Comments
    @selectedPost = new WEB.Models.Post
    @team = new WEB.Models.Team
    @user = new WEB.Models.User
  
  openSidebar: ->
    $('.sidebar').animate({'right':'-300px'}, 300)
    $('#panel').delay(300).animate({'right':'0px'}, 400).addClass('loading')
    
  addComments: (comments) =>
    $("#panel").removeClass "loading"
    @$("#panel .items").append (comments.map (comment) =>
      @commentTemplate( comment.asJSON() )
    ).join('')
  
  addComment: (comment) =>
    @$("#panel .items").append(@commentTemplate( comment.asJSON() ))
      
  renderPost: (postId) =>
    @selectedPost.url = "/posts/" + postId
    @selectedPost.fetch success: (post) =>
      @renderPostTemplate(post)
      @setHeader(post.get('user').name)
  
  renderPostTemplate: (post) =>
    $("#panel .post").html @postTemplate( post.asJSON() )
    
  setHeader: (name) =>
    $("#panel .header h1").html name + ":"    
        
  renderComments: (postId) =>
    $("#panel .items").html @form(id: postId)
    @comments.url = "/posts/" + postId + "/comments"
    @comments.fetch success: (comments) =>
      @addComments(comments)
    @renderPost(postId)
    return this
  
  renderUser: (userId) =>
    @user.url = "/users/" + userId
    @user.fetch success: (user) =>
      $("#panel").removeClass "loading"
      $("#panel #content").html @userTemplate( user.asJSON() )
      for team in user.get('teams')
        $("#panel #content .teams").append('<div class="team">' + team.name + '</div>')
      @setHeader("User")
    return this

  linkify: (text) ->
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    return text.replace(exp,"<a href='$1' target='_blank'>$1</a>")
      
  events: 
    "click .post .likes .comments" : "openComments"
    "click .post .author" : "openUser"
    "click #panel .header .close" : "closePanel"
    'keypress form#new_comment textarea' : 'newComment'
    "click #panel .post img" : "openImage"
 
  openImage: (event) ->
    $("#photobox").addClass('active')
    post = @selectedPost
    $("#photobox .image").html(@photobox( post.asJSON() ))
    $("#photobox .image").addClass 'loading'
    $("#photobox .image img").on 'load', ->
      $("#photobox .image").removeClass 'loading'
  
  openComments: (event) =>
    @openSidebar()
    $('#panel #content').html @commentsContainer
    postId = $(event.target).data('id')
    @renderComments(postId)
  
  openUser: (event) =>
    @openSidebar()
    $('#panel #content').html @userContainer
    userId = $(event.target).data('user_id')
    @renderUser(userId)
    
  closePanel: =>
    $('#panel').animate({'right':'-300px'}, 300)
    $('.sidebar').delay(300).animate({'right':'0px'}, 400)
  
  newComment: (event) =>
    newComment = new WEB.Models.Comment
    $("form#new_comment").backboneLink(newComment)
    if event.keyCode == 13 && $(event.target).val() != ''
      body = @linkify $("form#new_comment textarea").val()
      newComment.set
        user_id: WEB.currentUser.id
        post_id: $(event.target).data('id')
        body: body
      @comments.create(newComment,
        success: (comment) =>
          $("form#new_comment textarea").val('')
          @addComment(comment)
          comment.sendNewCommentEmail()
        error: (post, jqXHR) =>
          newComment.set({errors: $.parseJSON(jqXHR.responseText)})
      )