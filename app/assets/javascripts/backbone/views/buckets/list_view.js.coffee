WEB.Views.Buckets ||= {}
WEB.event = _.extend({}, Backbone.Events)

class WEB.Views.Buckets.ListView extends Backbone.View
  template: JST["backbone/templates/buckets/list"]

  initialize: () ->
    @options.buckets.bind('reset', @addAll)
    _.bindAll(@)
    
  addAll: () =>
    @options.buckets.each(@addOne)

  addOne: (bucket) =>
    view = new WEB.Views.Buckets.BucketView({model : bucket, currentId: @options.id })
    @$("#buckets").prepend(view.render().el)
    
  render: =>
    $(@el).html(@template(buckets: @options.buckets.toJSON()))
    @addAll()
    return this
    
  events: 
    "click #buckets_form .show_form" : "showForm"
    "click #buckets_form .form button" : "newBucket"
  
  showForm: (event) ->
    $(event.target).hide()
    $("#buckets_form .form").fadeIn(300)
    $("#buckets_form .form input").focus()
    height = $("#buckets").height() - 120
    $("#buckets").height(height + 'px')
  
  closeForm: ->
    $("#buckets_form .form").hide()
    $("#buckets_form .show_form").fadeIn(300)
    
  newBucket: (event) ->
    @bucket = new WEB.Models.Bucket
      name: $("#buckets_form .form input.bucket_name").val()
      description: $("#buckets_form .form textarea.bucket_description").val()
    @bucket.save(@bucket,
      success: (bucket) =>
        @bucket = bucket
        @options.buckets.add(bucket)
        @closeForm()
        @render()
    )
    