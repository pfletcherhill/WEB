WEB.Views.Posts ||= {}

class WEB.Views.Posts.BucketPostView extends Backbone.View
  template: JST["backbone/templates/posts/bucket_post"]
  
  initialize: () ->
    _.bindAll(@)    
    
  events:
    "click .like" : "toggleLike"
    "click .remove" : "remove"

  tagName: "post"
  
  remove: (event) ->
    if confirm "Are you sure you want to remove this post from the bucket?"
      @model.removeFromBucket(@options.bucket.get('id')).then @renderList
        
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
    @model.fetchUser(userId).then @applyTemplate
    @model.fetchLikes(postId).then @applyTemplate
    return this
  
  applyTemplate: _.after(2, ->
    $(@el).html(@template( @model.asJSON() ))
    @likePosts()
  )
  
  likePosts: =>
    if $.inArray(WEB.currentUser.id, @model.get('likes')) > -1
      $('.post .info').find(".like[data-id=#{@model.id}]").html('<span class="unicode">&#x2661;</span> Liked').addClass("liked")
