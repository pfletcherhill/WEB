WEB.Views.Posts ||= {}

class WEB.Views.Posts.IndexView extends Backbone.View
  template: JST["backbone/templates/posts/index"]
  profile: JST["backbone/templates/users/profile"]
  editUserForm: JST["backbone/templates/users/edit"]

  initialize: () ->
    @options.posts.bind('reset', @addAll)
    
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new WEB.Views.Posts.PostView({model : post})
    @$("#posts").prepend(view.render().el)
  
  renderEditProfile: (user) ->
    $("#edit_user_form").html(@editUserForm( user.toJSON() ))
    @$("form#update-user").backboneLink(user)
  
  renderProfile: (user) ->
    $("#my_profile").html(@profile( user.toJSON() ))
    
  render: =>
    @post = new @options.posts.model()
    $(@el).html(@template())
    @addAll()
    @$("form#new-user").backboneLink(@post)
    @renderEditProfile(WEB.currentUser)
    @renderProfile(WEB.currentUser)

    return this
           
  events:
    "submit #new-post" : "save"
    "click .button.text" : "newText"
    "submit #update-user" : 'saveUser'
    "dragstart" : 'dragstartPost'
    
  dragstartPost: (event) ->
    postId = $(event.target).data('post_id')
    event.dataTransfer.setData('post_id',postId)
      
  linkify: (text) ->
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    return text.replace(exp,"<a href='$1' target='_blank'>$1</a>")
  
  spacify: (text) ->
    return text.replace(/\r?\n/g, '<br/>')
  
  newText: ->
    $(".button").hide()
    $(".text_form").show()
    $(".text_form textarea").focus()
  
  saveUser: (event) ->
        
    event.preventDefault()
    event.stopPropagation()

    user = WEB.currentUser
    user.unset("errors")
        
    user.set
      name: $('#edit_user_form input#name').val(),
      email: $('#edit_user_form input#email').val(),
      school: $('#edit_user_form input#school').val(),
      year: $('#edit_user_form input#year').val(),
      bio: $('#edit_user_form textarea#bio').html()
     
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