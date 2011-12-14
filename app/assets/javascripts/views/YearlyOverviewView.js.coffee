class utgifter.views.YearlyOverviewView extends Backbone.View
  template: JST['overview/yearly']

  views: []

  initialize: (options) ->
    utgifter.collections.transactionCollection.bind('all', @reRenderGraph)
    _.extend(@, new utgifter.mixins.YearFilterButtons())
    @year = options.year

  render: ->
    $(@el).html(@template)
    @renderYearFilterButtons(@collection)
    @

  reRenderGraph: =>
    for view in @views
      view.destroy()
    @views = []
    @views.length = 0

    @renderGraph()

  renderGraph: ->
    result = utgifter.charts.dataGenerator({transactions: @collection.byYear(@year)})
    chart = new utgifter.views.BarChart(result.categories, result.series)
    chart.render()
    @views.push(chart)

  path: (year) ->
    "#overview/#{year}/yearly"

  leave: ->
    utgifter.collections.transactionCollection.unbind('all', @reRenderGraph)
