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
      @model.unlike(postId).then @resetLikes
      console.log $(event.target).parent()
      #$(event.target).parent().removeClass 'liked'
    else
      @model.like(postId).then @resetLikes
      console.log $(event.target).parent()
      #$(event.target).parent().addClass 'liked'

  resetLikes: =>
    @model.fetchLikes().then @applyTemplate
    
  render: =>
    userId = @model.get('user_id')
    postId = @model.get('id')
    @applyTemplate()
    return this
  
  applyTemplate: =>
    $(@el).html(@postTemplate( @model.asJSON() ))
    @renderLiked()

  renderLiked: =>
    ids = @model.get('likes').map (like) =>
      like.user_id
    console.log ids
    if $.inArray(WEB.currentUser.id, ids) > -1
      @$('.post .details .likes').addClass 'liked'