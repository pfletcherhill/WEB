WEB.Views.Posts ||= {}

class WEB.Views.Posts.IndexView extends Backbone.View
  template: JST["backbone/templates/posts/index"]

  initialize: () ->
    @options.posts.bind('reset', @addAll)

  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new WEB.Views.Posts.PostView({model : post})
    @$("#posts").prepend(view.render().el)

  render: =>
    @post = new @options.posts.model()
    $(@el).html(@template(posts: @options.posts.toJSON() ))
    @addAll()
    @$("form").backboneLink(@post)

    return this
  
  likeAll: =>
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/user/likes'
      success: (likes) =>
        likes.map( (like) ->
          likeId = like.id
          $(".post").find('data-id',likeId)
          $(".post .info .like").addClass 'liked'
        )
          
  events:
    "submit #new-post": "save"
  
  linkify: (text) ->
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    return text.replace(exp,"<a href='$1'>$1</a>")
  
  spacify: (text) ->
    return text.replace(/\r?\n/g, '<br/>')
    
  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @post.unset("errors")
    
    string = @spacify $(".form form textarea").val()
    body = @linkify string
    
    @post.set
      user_id: WEB.currentUser.id
      team_id: WEB.currentUser.get('team_id')
      body: body
    
    @post.save
            
    @options.posts.create(@post,
      success: (post) =>
        @post = post
        $(".item.new").removeClass "close_form"
        $(".item.new h1").html("+")
        @render()

      error: (post, jqXHR) =>
        @post.set({errors: $.parseJSON(jqXHR.responseText)})
    )