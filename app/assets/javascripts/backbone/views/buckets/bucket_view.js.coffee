WEB.Views.Buckets ||= {}

class WEB.Views.Buckets.BucketView extends Backbone.View
  template: JST["backbone/templates/buckets/bucket"]
  
  initialize: ->
    _.bindAll(@)
  
  render: =>
    userId = @model.get('user_id')
    bucketId = @model.get('id')
    @model.fetchUser(userId).then @applyTemplate
    @model.fetchPosts(bucketId).then @applyTemplate
    return this

  applyTemplate: _.after(2, ->
    $(@el).html(@template(@model.asJSON()))
    $(@el).find('.bucket[data-id=' + @options.currentId + ']').addClass 'selected'
  )

  events:
    "drop .bucket" : "dropPost"
    "dragenter .bucket" : "dragoverBucket"
    "dragleave .bucket" : "dragleaveBucket"
    
  dragoverBucket: (event) =>
    $target = $(event.target).parent()
    $target.addClass 'dragover'
    #height = $target.height() - 6
    #$target.height(height)
  
  dragleaveBucket: (event) =>
    $target = $(event.target).parent()
    $target.removeClass 'dragover'
    #height = $target.height() + 6
    #$target.height(height)
      
  dropPost: (event) =>
    event.preventDefault()
    postId = event.dataTransfer.getData('post_id')
    @model.addPost(@model.get('id'), postId).then @completeDrop(event)
  
  completeDrop: (event) ->
    @render()
    $(event.target).trigger 'click'