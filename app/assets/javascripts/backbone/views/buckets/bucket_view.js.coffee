WEB.Views.Buckets ||= {}

class WEB.Views.Buckets.BucketView extends Backbone.View
  template: JST["backbone/templates/buckets/bucket"]
  
  initialize: ->
    _.bindAll(@)
    @posts = new WEB.Collections.PostsCollection()
    @posts.url = "/bucket/" + @model.get('id') + "/posts"
  
  render: =>
    userId = @model.get('user_id')
    bucketId = @model.get('id')
    @model.fetchUser(userId).then @applyTemplate
    @model.fetchPosts(bucketId).then @applyTemplate
    return this

  applyTemplate: _.after(2, ->
    $(@el).html(@template(@model.asJSON()))
  )

  events:
    "click .bucket:not(.selected)": "openPosts"
    "click .bucket.selected": "closePosts"
    "drop .bucket" : "dropPost"
    "dragenter .bucket" : "dragoverBucket"
    "dragleave .bucket" : "dragleaveBucket"
  
  dragoverBucket: (event) =>
    $target = $(event.target)
    $target.addClass 'dragover'
  
  dragleaveBucket: (event) =>
    $target = $(event.target)
    $target.removeClass 'dragover'
      
  dropPost: (event) =>
    event.preventDefault()
    postId = event.dataTransfer.getData('post_id')
    @model.addPost(@model.get('id'), postId).then @completeDrop(event)
  
  completeDrop: (event) ->
    @render()
    $(event.target).trigger 'click'
  
  openPosts: (event) ->
    $('.bucket').removeClass 'selected'
    $target = $(event.target)
    if $target.is('h5') || $target.is('.user')
      $target.parent().parent().addClass 'selected'
    else
      $target.addClass 'selected'
    $("#bucket_container").show().animate({"right":"300px"})
    $(".container").width($(window).width() - 720 + 'px')
    @posts.fetch success: (bucketPosts) =>
      view = new WEB.Views.Posts.BucketView(posts: bucketPosts, bucket: @model)
      $("#bucket_container").html(view.render().el)
    
  
  closePosts: (event) ->
    $(".bucket").removeClass 'selected'
    $("#bucket_container").animate({"right":"0px"}, 300, ->
      $('#bucket_container').hide())
    $(".container").removeAttr 'style'
