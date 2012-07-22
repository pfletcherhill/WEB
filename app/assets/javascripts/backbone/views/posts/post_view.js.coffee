class WEB.Views.Posts.PostView extends Backbone.View
  postTemplate: JST["backbone/templates/posts/post"]
  myTemplate: JST["backbone/templates/posts/mypost"]
  
  initialize: () ->
    _.bindAll(@)    
    
  events:
    "click .destroy" : "destroy"
    "click .like" : "like"

  tagName: "post"

  destroy: () ->
    if confirm "Are you sure you want to delete your post?"
      @model.destroy()
      this.remove()

    return false
  
  like: (event) ->
    if $(event.target).hasClass 'liked'
      @model.unlike(postId)
      $(event.target).removeClass('liked').html('Like')
    else
      postId = $(event.target).data('id')
      @model.like(postId)
      $(event.target).addClass('liked').html('Liked')

  render: =>
    userId = @model.get('user_id')
    postId = @model.get('id')
    if userId == WEB.currentUser.id
      @model.fetchUser(userId).then @applyMyTemplate
      @model.fetchLikes(postId).then @applyMyTemplate
    else
      @model.fetchUser(userId).then @applyPostTemplate
      @model.fetchLikes(postId).then @applyPostTemplate
    return this
  
  applyPostTemplate: _.after(2, ->
    $(@el).html(@postTemplate( @model.asJSON() ))
    @likePosts()
  )
  
  applyMyTemplate: _.after(2, ->
    $(@el).html(@myTemplate( @model.asJSON() ))
    @likePosts()
  )
  
  likePosts: =>
    if $.inArray(WEB.currentUser.id, @model.get('likes')) > -1
      console.log @model.id
      $('.post .info').find(".like[data-id=#{@model.id}]").html('Liked').addClass("liked")
    else
      console.log 'not liked'