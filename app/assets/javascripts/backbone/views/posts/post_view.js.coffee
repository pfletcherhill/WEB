class WEB.Views.Posts.PostView extends Backbone.View
  postTemplate: JST["backbone/templates/posts/post"]
  myTemplate: JST["backbone/templates/posts/mypost"]
  
  initialize: () ->
    _.bindAll(@)    
    
  events:
    "click .destroy" : "destroy"
    "click .like" : "toggleLike"

  tagName: "post"

  destroy: () ->
    if confirm "Are you sure you want to delete your post?"
      @model.destroy()
      this.remove()

    return false
  
  toggleLike: (event) ->
    postId = $(event.target).data('id')
    if $(event.target).hasClass 'liked'
      @model.unlike(postId)
      $(event.target).html('<span class="unicode">&#x2661;</span> Like').removeClass('liked')
    else
      @model.like(postId)
      $(event.target).html('<span class="unicode">&#x2661;</span> Liked').addClass('liked')

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
      $('.post .info').find(".like[data-id=#{@model.id}]").html('<span class="unicode">&#x2661;</span> Liked').addClass("liked")
