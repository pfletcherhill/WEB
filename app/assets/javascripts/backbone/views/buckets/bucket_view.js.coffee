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
  
  openPosts: (event) ->
    $('.bucket').removeClass 'selected'
    $(event.target).parent().parent().addClass 'selected'
    $("#bucket_container").show().animate({"right":"300px"})
    $(".container").addClass 'bucket_posts_open'
    @posts.fetch success: (bucketPosts) =>
      view = new WEB.Views.Posts.BucketView(posts: bucketPosts, bucket: @model)
      $("#bucket_container").html(view.render().el)
    
  
  closePosts: (event) ->
    $(".bucket").removeClass 'selected'
    $("#bucket_container").animate({"right":"0px"}, 300, ->
      $('#bucket_container').hide())
    $(".container").removeClass 'bucket_posts_open'