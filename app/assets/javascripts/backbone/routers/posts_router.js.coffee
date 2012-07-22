class WEB.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @posts = new WEB.Collections.PostsCollection()
    
  routes:
    ".*"        : "index"
    "team"      : "team"
    "likes"     : "likes"

  index: =>
    $("#posts").html('loading')
    @posts.url = "/promoted"
    @posts.fetch success: (promotedPosts) =>
      @view = new WEB.Views.Posts.IndexView(posts: promotedPosts)
      $("#posts").html(@view.render().el)
    
  team: ->
    $("#posts").html('loading')
    @posts.url = "/posts"
    @posts.fetch success: (teamPosts) =>
      @view = new WEB.Views.Posts.IndexView(posts: teamPosts)
      $("#posts").html(@view.render().el)
      $("#pointer").fadeIn(200).css({"top":"146px"})
      $(".item.new").fadeIn(100)
  
  likes: ->
    $(".item.new").hide()
    $("#posts").html('loading')
    @posts.url = "/user/likes"
    @posts.fetch success: (likedPosts) =>
      @view = new WEB.Views.Posts.IndexView(posts: likedPosts)
      $("#pointer").fadeIn(200).css({"top":"246px"})
      $("#posts").html(@view.render().el)