class WEB.Routers.PostsRouter extends Backbone.Router
  
  initialize: (options) ->
    @fetchUser()
    #@initializeComments()
    @initializeSidebar()
  
  fetchBuckets: (teamId) =>
    @buckets = new WEB.Collections.Buckets()
    @buckets.url = "/team/" + teamId + "/buckets"
    @buckets.fetch success: (buckets) =>
      @buckets = buckets
      view = new WEB.Views.Buckets.ListView(buckets: buckets, id: @bucketId)
      $("#containers").html(view.render().el)     
  
  fetchUser: =>
    @user = new WEB.Models.User()
    @user.url = "/me"
    @user.fetch success: (user) =>
      view = new WEB.Views.Users.IndexView()
      view.render()
      teamId = user.get('team_id')
      @fetchTeam(teamId)
  
  fetchTeam: (teamId) =>
    @team = new WEB.Models.Team()
    @team.url = "/teams/" + teamId
    @team.fetch success: (team) =>
      @team = team
  
  initializeComments: =>
    view = new WEB.Views.Comments.IndexView()
    view.initialize()
  
  initializeSidebar: =>
    view = new WEB.Views.Sidebar.IndexView()
    view.initialize()
      
  routes:
    "team/:id"           : "team"
    "likes"              : "likes"
    "bucket/:id"         : "bucket"
    "post/:id"           : "post"
    ".*"                 : "index"

  index: =>
    $("#buckets .bucket").removeClass 'selected'
    posts = new WEB.Collections.Posts
    posts.url = "/promoted"
    posts.fetch success: (posts) =>
      view = new WEB.Views.Posts.PromotedView(posts: posts)
      $("#posts").html(view.render().el)
    
  team: (id) =>
    $("#buckets .bucket").removeClass 'selected'
    $("#posts").html('<div id="preloader">Loading...</div>').addClass 'loading'
    team = new WEB.Models.Team
    team.url = "/teams/" + id
    team.fetch
      success: (team) =>
        @fetchBuckets(team.id)
        posts = new WEB.Collections.Posts
        posts.url = "teams/" + id + "/posts"
        posts.fetch
          success: (posts) =>
            view = new WEB.Views.Posts.IndexView(posts: posts, team: team)
            title = team.get('name')
            $("#posts").html(view.render(title).el)
            $("#pointer").fadeIn(200).css({"top":"146px"})
            $(".item.new").fadeIn(100).html('<h1>+</h1>').removeClass 'close_form'
          error: =>
  
  likes: =>
    $("#buckets .bucket").removeClass 'selected'
    $(".item.new").hide()
    $("#posts").html('<div id="preloader">Loading...</div>').addClass 'loading'
    posts = new WEB.Collections.Posts
    posts.url = "/user/likes"
    posts.fetch success: (likedPosts) =>
      @view = new WEB.Views.Posts.IndexView(posts: likedPosts)
      $("#pointer").fadeIn(200).css({"top":"246px"})
      $("#posts").html(@view.render('Your Likes').el)
  
  bucket: (id) =>
    $("#buckets .bucket").removeClass 'selected'
    $("#posts").html('').addClass 'loading'
    $(".item.new").hide()
    @bucketId = id
    bucket = new WEB.Models.Bucket()
    bucket.url = "/buckets/" + id
    bucket.fetch success: (bucket) =>
      title = bucket.get('name') + " Posts"
      bucketPosts = new WEB.Collections.Posts()
      bucketPosts.add(bucket.get('posts'))
      @view = new WEB.Views.Posts.IndexView(posts: bucketPosts)
      $("#posts").html(@view.render(title).el)
      $("#pointer").fadeOut(100)
      $(".buckets .collapsible").show().addClass 'open'
      $("#buckets").find(".bucket[data-id='#{id}']").addClass 'selected'
  
  post: (id) =>
    $("#posts").html('<div id="preloader">Loading...</div>').addClass 'loading'
    $(".item.new").hide()
    @postId = id
    @post = new WEB.Models.Post
    @post.url = "/posts/" + id
    @post.fetch success: (post) =>
      @view = new WEB.Views.Posts.ShowView(model: post)
      $("#posts").html(@view.render().el)
      $("#pointer").fadeOut(100)