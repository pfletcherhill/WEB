class WEB.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @posts = new WEB.Collections.PostsCollection()
    @fetchBuckets()
  
  fetchBuckets: =>
    @buckets = new WEB.Collections.BucketsCollection()
    @buckets.url = "/team/buckets"
    @buckets.fetch success: (buckets) =>
      view = new WEB.Views.Buckets.ListView(buckets: buckets)
      $("#containers").html(view.render().el)    
        
  routes:
    ".*"        : "index"
    "team"      : "team"
    "likes"     : "likes"

  index: =>
    $("#posts").html('loading')
    @posts.url = "/promoted"
    @posts.fetch success: (promotedPosts) =>
      @view = new WEB.Views.Posts.PromotedView(posts: promotedPosts)
      $("#posts").html(@view.render().el)
    
  team: ->
    $("#posts").html('loading')
    @posts.url = "/posts"
    @posts.fetch success: (teamPosts) =>
      @view = new WEB.Views.Posts.IndexView(posts: teamPosts)
      $("#posts").html(@view.render().el)
      $("#pointer").fadeIn(200).css({"top":"146px"})
      $(".item.new").fadeIn(100).html('<h1>+</h1>').removeClass 'close_form'
  
  likes: ->
    $(".item.new").hide()
    $("#posts").html('loading')
    @posts.url = "/user/likes"
    @posts.fetch success: (likedPosts) =>
      @view = new WEB.Views.Posts.IndexView(posts: likedPosts)
      $("#pointer").fadeIn(200).css({"top":"246px"})
      $("#posts").html(@view.render().el)