WEB.Views.Posts ||= {}

class WEB.Views.Posts.IndexView extends Backbone.View
  template: JST["backbone/templates/posts/index"]
  profile: JST["backbone/templates/users/profile"]
  editUserForm: JST["backbone/templates/users/edit"]
  photobox: JST["backbone/templates/posts/photobox"]

  initialize: () ->
    @options.posts.bind('reset', @addAll)
    
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new WEB.Views.Posts.PostView({model : post})
    @$("#posts").prepend(view.render().el)
  
  renderEditProfile: (user) ->
    @$(".preferences #edit_user_form").html(@editUserForm( user.toJSON() ))
    @$("form#update-user").backboneLink(user)
  
  renderProfile: (user) ->
    $("#my_profile").html(@profile( user.toJSON() ))
  
  renderUpload: =>
    $("#new_image").fileupload
      dataType: "json"
      autoUpload: true
      done: (e, data) =>
        $(".button.image .message").html('Loaded!')
        $.each data.result, (index, file) =>
          url = file.thumbnail_url
          $(".button.image").removeClass 'empty'
          $(".button.image").html('<div class="preview"><img src=' + url + ' />Image Added</div>')
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
         
  render: =>
    @post = new @options.posts.model()
    $(@el).html(@template())
    @addAll()
    @$("form#new-user").backboneLink(@post)
    @renderEditProfile(WEB.currentUser)
    @renderProfile(WEB.currentUser)
    @renderUpload()
    @noPosts()
    return this

  linkify: (text) ->
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    return text.replace(exp,"<a href='$1' target='_blank'>$1</a>")

  spacify: (text) ->
    return text.replace(/\r?\n/g, '<br/>')
    
  events:
    "dragstart" : 'dragstartPost'
    "click .button.text" : "newText"
    "click .button.image.empty" : "newImage"
    "submit form#update-user" : 'saveUser'
    "submit form#new_post" : "save"
    "click .post img" : "openImage"
    "click #photobox .opacity" : "closeImage"
    "click .preferences .header .close" : "closePreferences"
  
  closePreferences: ->
    $('.preferences').animate({'right':'-300px'}, 400)
    $('.sidebar').delay(500).animate({'right':'0px'}, 400)
    
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
    
  saveUser: (event) ->
    event.preventDefault()
    event.stopPropagation()
        
    user = WEB.currentUser
    user.url = '/users/' + user.get('id')
    user.save user.changed,
      success: (user) =>
        @closePreferences()
        @renderProfile(user)
        $(".profile .name.user").click()

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
      image_id: @image.id if @image
    @options.posts.create(@post,
      success: (post) =>
        $(".item.new").removeClass "close_form"
        $(".item.new h1").html("+")
        @render()
        
      error: (post, jqXHR) =>
        @post.set({errors: $.parseJSON(jqXHR.responseText)})
    )