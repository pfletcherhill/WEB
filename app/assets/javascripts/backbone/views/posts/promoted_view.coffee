WEB.Views.Posts ||= {}

class WEB.Views.Posts.PromotedView extends Backbone.View
  template: JST["backbone/templates/posts/promoted_index"]
  profile: JST["backbone/templates/users/profile"]
  editUserForm: JST["backbone/templates/users/edit"]

  initialize: () ->
    @options.posts.bind('reset', @addAll)
    
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new WEB.Views.Posts.PromotedPostView({model : post})
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