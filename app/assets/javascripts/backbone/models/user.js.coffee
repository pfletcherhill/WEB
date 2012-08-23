class WEB.Models.User extends Backbone.Model
  
  defaults: ->
    'name': null
    'email': null
    'admin': false
    'school': null
    'year': null
    'team_id': null
    'bio': null
  
  fetchLikes: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/' + @get('id') + '/likes'
      success: (data) =>
        @set likes: data
  
  asJSON: =>
    user = _.clone this.attributes
    return _.extend user, { team: this.get('team') }
  
class WEB.Collections.Users extends Backbone.Collection
  model: WEB.Models.User