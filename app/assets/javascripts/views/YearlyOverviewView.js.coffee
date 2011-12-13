class utgifter.views.YearlyOverviewView extends Backbone.View
  template: JST['overview/yearly']

  views: []

  initialize: (options) ->
    _.extend(@, new utgifter.mixins.YearFilterButtons())
    @year = options.year

  render: ->
    $(@el).html(@template)
    @renderYearFilterButtons(@collection)
    @

  renderGraph: ->
    renderChartTo = $(@el).find("#chartContainer")
    result = utgifter.charts.dataGenerator({transactions: @collection.byYear(@year)})
    chart = new utgifter.views.BarChart(result.categories, result.series, renderChartTo)
    @views.push(chart)

  path: (year) ->
    "#overview/#{year}/yearly"
