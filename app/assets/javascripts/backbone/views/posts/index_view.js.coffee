WEB.Views.Posts ||= {}

class WEB.Views.Posts.IndexView extends Backbone.View
  template: JST["backbone/templates/posts/index"]
  photobox: JST["backbone/templates/posts/photobox"]
  
  initialize: () ->
    @options.posts.bind('reset', @addAll)
    
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new WEB.Views.Posts.PostView({model : post})
    @$("#posts").prepend(view.render().el)
  
  renderUpload: =>
    $("input.add_post").attr('disabled','disabled')
    $("#new_image").fileupload
      dataType: "json"
      autoUpload: true
      done: (e, data) =>
        $(".button.image .message").html('Loaded!')
        $.each data.result, (index, file) =>
          url = file.thumbnail_url
          $(".button.image").removeClass 'empty'
          $(".button.image").html('<div class="preview"><img src=' + url + ' /></div>')
          $("input.add_post").attr('disabled',null)
          @image = file
      fail: (e, data) ->
        $(".button.image .message").html('Upload Failed')
      start: (e, data) ->
        $(".button.image .message").html('Processing...')
        $('.button.image .image_loader').animate({"width":"160px"}, 1100)
  
  noPosts: =>
    if @options.posts.length == 0
      @$("#posts").html("<div class='no_posts'>No Posts Yet</div>")      
      @$("#posts .no_posts").fadeIn(300)   
  
  preloader: =>
    $("#posts").stop().removeClass 'loading'
             
  render: (title) =>
    $("#posts").addClass 'loading'
    $(@el).html(@template( title: title ))
    @addAll()
    @setupWorkspace()
    @noPosts()
    @setPostsWidth()
    return this

  setupWorkspace: =>
    _.delay @preloader, 1000
    @post = new WEB.Models.Post()
    @renderUpload()
    $(".container .form textarea").val('')
    $(".container .form").hide()
    
  linkify: (text) ->
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    return text.replace(exp,"<a href='$1' target='_blank'>$1</a>")

  spacify: (text) ->
    return text.replace(/\r?\n/g, '<br/>')
    
  events:
    "dragstart" : 'dragstartPost'
    "click .button.text" : "newText"
    "click .button.image.empty" : "newImage"
    "submit form#new_post" : "save"
    "click .post img" : "openImage"
    "click #photobox .opacity" : "closeImage"
    
  setPostsWidth: ->
    width = $(window).width() - 400
    number = width / 300
    integer = Math.floor(number) * 290
    @$(".container .items").width(integer)
    
  openImage: (event) ->
    $("#photobox").addClass('active')
    id = $(event.target).data('id')
    post = @options.posts.get(id)
    $("#photobox .image").html(@photobox( post.asJSON() ))
    $("#photobox .image").addClass 'loading'
    $("#photobox .image img").on 'load', ->
      $("#photobox .image").removeClass 'loading'
  
  closeImage: (event) ->
    $("#photobox").removeClass 'active'
    $("#photobox .image").html('')
    
  dragstartPost: (event) ->
    postId = $(event.target).data('post_id')
    event.dataTransfer.setData('post_id',postId)
  
  newText: ->
    $(".button").hide()
    $(".text_form").show()
    $(".text_form textarea").focus()
  
  newImage: ->
    @renderUpload()
    $(".upload input[type='file']").click()
    false

  save: (e) -> 
    e.preventDefault()
    e.stopPropagation()
    @post.unset("errors")
    string = @spacify $(".form form textarea").val()
    body = @linkify string
    @post.url = "/posts"
    @post.set
      user_id: WEB.currentUser.id
      team_id: WEB.currentUser.get('team_id')
      body: body
      image_id: @image.id if @image
    $("#posts").addClass 'loading'
    @options.posts.create(@post,
      success: (post) =>
        $(".item.new").removeClass "close_form"
        $(".item.new h1").html("+")
        @addOne(post)
        @setupWorkspace()
        post.sendNewPostEmail()
        
      error: (post, jqXHR) =>
        $("#posts").removeClass 'loading'
        @post.set({errors: $.parseJSON(jqXHR.responseText)})
    )