class WEB.Views.Posts.PostView extends Backbone.View
  postTemplate: JST["backbone/templates/posts/post"]
  myTemplate: JST["backbone/templates/posts/mypost"]
  
  initialize: () ->
    _.bindAll(@)    
    
  events:
    "click .destroy" : "destroy"
    "click .likes span.unicode" : "toggleLike"

  tagName: "post"

  destroy: () ->
    if confirm "Are you sure you want to delete your post?"
      @model.destroy()
      this.remove()
    return false
  
  toggleLike: (event) ->
    postId = $(event.target).parent().data('id')
    if $(event.target).parent().hasClass 'liked'
      @model.unlike(postId).then @render
      $(event.target).parent().removeClass 'liked'
    else
      @model.like(postId).then @render
      $(event.target).parent().addClass 'liked'

  render: =>
    @$(".post").addClass "processing"
    userId = @model.get('user_id')
    postId = @model.get('id')
    if userId == WEB.currentUser.id
      @model.fetchUser(userId).then @applyMyTemplate
      @model.fetchLikes(postId).then @applyMyTemplate
      @model.fetchImage(postId).then @applyMyTemplate
      @model.fetchComments(postId).then @applyMyTemplate
    else
      @model.fetchUser(userId).then @applyPostTemplate
      @model.fetchLikes(postId).then @applyPostTemplate
      @model.fetchImage(postId).then @applyPostTemplate
      @model.fetchComments(postId).then @applyPostTemplate
    return this
  
  applyPostTemplate: _.after(4, ->
    $(@el).html(@postTemplate( @model.asJSON() ))
    @likePosts()
    _.delay @$(".post").removeClass 'processing', 500
  )
  
  applyMyTemplate: _.after(4, ->
    $(@el).html(@myTemplate( @model.asJSON() ))
    @likePosts()
    _.delay @$(".post").removeClass 'processing', 500
  )
  
  likePosts: =>
    if $.inArray(WEB.currentUser.id, @model.get('likes')) > -1
      $('.post .details').find(".likes[data-id=#{@model.id}]").addClass("liked")
