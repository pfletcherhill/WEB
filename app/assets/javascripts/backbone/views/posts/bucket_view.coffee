WEB.Views.Posts ||= {}

class WEB.Views.Posts.BucketView extends Backbone.View
  template: JST["backbone/templates/posts/bucket"]

  initialize: () ->
    @options.posts.bind('reset', @addAll)
    
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new WEB.Views.Posts.BucketPostView({model : post, bucket: @options.bucket})
    @$("#bucket_posts").prepend(view.render().el)

  render: =>
    @post = new @options.posts.model()
    $(@el).html(@template(posts: @options.posts.toJSON()))
    @addAll()
    return this