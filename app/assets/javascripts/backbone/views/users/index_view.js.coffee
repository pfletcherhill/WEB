WEB.Views.Users ||= {}

class WEB.Views.Users.IndexView extends Backbone.View
  template: JST["backbone/templates/users/index"]
  editUserForm: JST["backbone/templates/users/edit"]
  profile: JST["backbone/templates/users/profile"]
  
  el: 'body'
  
  initialize: () ->
    
  renderEditProfile: (user) ->
    $(".preferences #edit_user_form").html(@editUserForm( user.toJSON() ))
    $("form#update-user").backboneLink(user)
  
  renderProfile: (user) ->
    $("#my_profile").html(@profile( user.toJSON() ))  
         
  render: =>
    $('#user').html(@template())
    @renderEditProfile(WEB.currentUser)
    @renderProfile(WEB.currentUser)
    return this

  events:
    "click .header .edit_profile" : "openPreferences"
    "submit form#update-user" : 'saveUser'
    "click .preferences .header .close" : "closePreferences"
  
  openPreferences: ->
    $('.sidebar').animate({'right':'-300px'}, 400)
    $('.preferences').delay(500).animate({'right':'0px'}, 400)
    
  closePreferences: ->
    $('.preferences').animate({'right':'-300px'}, 400)
    $('.sidebar').delay(500).animate({'right':'0px'}, 400)
    
  saveUser: (event) ->
    event.preventDefault()
    event.stopPropagation()
        
    user = WEB.currentUser
    user.url = '/users/' + user.get('id')
    user.save user.changed,
      success: (user) =>
        @closePreferences()
        @renderProfile(user)