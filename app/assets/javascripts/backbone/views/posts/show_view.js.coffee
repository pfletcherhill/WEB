class WEB.Views.Posts.ShowView extends Backbone.View
  template: JST["backbone/templates/posts/show"]
  commentTemplate: JST["backbone/templates/comments/comment"]
  
  initialize: () ->
    _.bindAll(@)  
    @comments = new WEB.Collections.Comments
    @comments.add @model.get('comments')
    
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
    else
      @model.like(postId).then @resetLikes

  resetLikes: =>
    @model.fetchLikes().then @applyTemplate
    
  render: =>
    @applyTemplate()
    return this
  
  applyTemplate: =>
    $(@el).html(@template( @model.asJSON() ))
    $("#posts").removeClass 'loading'
    $(".container").children().on 'load', ->
      alert 'loaded'
    @renderComments()
    @renderLiked()
  
  renderComments: =>
    $(".container #comments .items").append (@comments.map (comment) =>
      @commentTemplate( comment.asJSON() )
    ).join('')

  renderLiked: =>
    ids = @model.get('likes').map (like) =>
      like.user_id
    if $.inArray(WEB.currentUser.id, ids) > -1
      @$('.single_post .details .likes').addClass 'liked'