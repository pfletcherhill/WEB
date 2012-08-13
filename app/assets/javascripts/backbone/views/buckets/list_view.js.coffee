WEB.Views.Buckets ||= {}

class WEB.Views.Buckets.ListView extends Backbone.View
  template: JST["backbone/templates/buckets/list"]

  initialize: () ->
    @options.buckets.bind('reset', @addAll)
    
  addAll: () =>
    @options.buckets.each(@addOne)

  addOne: (bucket) =>
    view = new WEB.Views.Buckets.BucketView({model : bucket})
    @$("#buckets").prepend(view.render().el)

  render: =>
    @bucket = new @options.buckets.model()
    $(@el).html(@template(buckets: @options.buckets.toJSON() ))
    @addAll()
    return this