class WEB.Models.Comment extends Backbone.Model
  
  urlRoot: "/comments"
  
  defaults: ->
    'body': null
    'user_id': WEB.currentUser.id
    'post_id': null
  
  fetchUser: () ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/' + @get('user_id')
      success: (data) =>
        @set user: data
        
  sendNewCommentEmail: () ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/new_comment_mailer/' + @get('id')
            
  asJSON: =>
    comment = _.clone @.attributes
    return _.extend comment, { user: @get('user') }
  
class WEB.Collections.Comments extends Backbone.Collection
  model: WEB.Models.Comment