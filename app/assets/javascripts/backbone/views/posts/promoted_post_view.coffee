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
    @applyTemplate()
    return this

  applyTemplate: =>
    $(@el).html(@template( @model.asJSON() ))
    @likePosts()
    @$(".body").addClass "loading"
    @$(".body img").on 'load', ->
      $(".body").removeClass('loading').addClass('loaded')
  
  likePosts: =>
    if $.inArray(WEB.currentUser.id, @model.get('likes')) > -1
      $('.promoted_post .details').find(".likes[data-id=#{@model.id}]").addClass("liked")
