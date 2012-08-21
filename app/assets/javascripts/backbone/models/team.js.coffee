class WEB.Models.Team extends Backbone.Model
  
  defaults: ->
    'name': null
    'description': null
  
class WEB.Collections.Teams extends Backbone.Collection
  model: WEB.Models.Team