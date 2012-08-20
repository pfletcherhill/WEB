WEB.Views.Posts ||= {}

class WEB.Views.Posts.PromotedView extends Backbone.View
  template: JST["backbone/templates/posts/promoted_index"]

  initialize: () ->
    @options.posts.bind('reset', @addAll)
    
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new WEB.Views.Posts.PromotedPostView({model : post})
    @$("#posts").prepend(view.render().el)
  
  preloader: =>
    $("#posts").removeClass 'loading'
      
  render: =>
    $("#posts").addClass 'loading'
    @post = new @options.posts.model()
    $(@el).html(@template())
    @addAll()
    $(window).on 'load', =>
      @preloader()
    return this