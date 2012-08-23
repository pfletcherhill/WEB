WEB.Views.Comments ||= {}

class WEB.Views.Comments.IndexView extends Backbone.View
  commentTemplate: JST["backbone/templates/comments/comment"]
  postTemplate: JST["backbone/templates/comments/post"]
  form: JST["backbone/templates/comments/form"]
  photobox: JST["backbone/templates/posts/photobox"]

  el: 'body'
  
  initialize: () ->
    _.bindAll(@) 
    @comments = new WEB.Collections.Comments
    @selectedPost = new WEB.Models.Post
  
  addAll: (comments) =>
    @comments = comments
    $("#comments").removeClass "loading"
    if comments.length != 0
      renderAll = _.after(comments.length, @renderComments)
    else
      return
    _.each(comments.models, (comment) =>
      comment.fetchUser().then renderAll
    )
    
  renderComments: =>
    @$("#comments .items").append (@comments.map (comment) =>
      @commentTemplate( comment.asJSON() )
    ).join('')
  
  addOne: (comment) =>
    comment.fetchUser().then =>
      @$("#comments .items").append(@commentTemplate( comment.asJSON() ))
      
  renderPost: (postId) =>
    @selectedPost.url = "/posts/" + postId
    @selectedPost.fetch success: (post) =>
      @selectedPost = post
      @renderPostTemplate()
      post.fetchImage(post.id).then @renderPostTemplate
      post.fetchUser(post.get('user_id')).then @setHeader
  
  renderPostTemplate: _.after(2, ->
    $("#comments .post").html @postTemplate( @selectedPost.asJSON() )
  )
    
  setHeader: =>
    name = @selectedPost.get('user').name
    $("#comments .header h1").html name + ":"    
        
  render: (postId) =>
    $("#comments .items").html @form(id: postId)
    @comments.url = "/posts/" + postId + "/comments"
    @comments.fetch success: (comments) =>
      @addAll(comments)
    @renderPost(postId)
    return this

  linkify: (text) ->
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    return text.replace(exp,"<a href='$1' target='_blank'>$1</a>")
      
  events: 
    "click .likes .comments" : "openComments"
    "click #comments .header .close" : "closeComments"
    'keypress form#new_comment textarea' : 'newComment'
    "click #comments .post img" : "openImage"
 
  openImage: (event) ->
    $("#photobox").addClass('active')
    post = @selectedPost
    $("#photobox .image").html(@photobox( post.asJSON() ))
    $("#photobox .image").addClass 'loading'
    $("#photobox .image img").on 'load', ->
      $("#photobox .image").removeClass 'loading'
  
  openComments: (event) ->
    $('.sidebar').animate({'right':'-300px'}, 300)
    $('#comments').delay(300).animate({'right':'0px'}, 400).addClass('loading')
    postId = $(event.target).data('id')
    @render(postId)
    
  closeComments: ->
    $('#comments').animate({'right':'-300px'}, 300)
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
          @addOne(comment)
          comment.sendNewCommentEmail()
        error: (post, jqXHR) =>
          newComment.set({errors: $.parseJSON(jqXHR.responseText)})
      )