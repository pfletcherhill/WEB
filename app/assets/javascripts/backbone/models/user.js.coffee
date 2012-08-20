class WEB.Models.User extends Backbone.Model
  
  defaults: ->
    'name': null
    'email': null
    'admin': false
    'school': null
    'year': null
    'team_id': null
    'bio': null
  
class WEB.Collections.UsersCollection extends Backbone.Collection
  model: WEB.Models.User