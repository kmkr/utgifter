class window.utgifter.views.IndexView extends Backbone.View
  template: JST['page/index']
  render: ->
    $(@el).append(@template)
    @
