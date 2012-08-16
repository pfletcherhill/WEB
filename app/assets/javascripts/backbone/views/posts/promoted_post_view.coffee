class WEB.Views.Posts.PromotedPostView extends Backbone.View
  template: JST["backbone/templates/posts/promoted_post"]
  
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
    userId = @model.get('user_id')
    postId = @model.get('id')
    teamId = @model.get('team_id')
    @model.fetchTeam(teamId).then @applyTemplate
    @model.fetchUser(userId).then @applyTemplate
    @model.fetchLikes(postId).then @applyTemplate
    return this

  applyTemplate: _.after(3, ->
    $(@el).html(@template( @model.asJSON() ))
    @likePosts()
  )
  
  likePosts: =>
    if $.inArray(WEB.currentUser.id, @model.get('likes')) > -1
      $('.promoted_post .details').find(".likes[data-id=#{@model.id}]").addClass("liked")
