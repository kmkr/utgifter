class utgifter.views.YearlyOverviewView extends Backbone.View
  template: JST['overview/yearly']

  initialize: (options) ->
    _.extend(@, new utgifter.mixins.YearFilterButtons())
    @year = options.year

  render: ->
    $(@el).html(@template)
    @renderYearFilterButtons(@collection)
    @

  renderGraph: ->
    @chart.destroy() if @chart
    renderChartTo = $(@el).find("#chartContainer")
    result = utgifter.charts.dataGenerator({transactions: @collection.byYear(@year)})
    @chart = new utgifter.charts.bar.BarChart(result.categories, result.series, renderChartTo)

  path: (year) ->
    "#overview/#{year}/yearly"

  leave: ->
    @chart.destroy()
