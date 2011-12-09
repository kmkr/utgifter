class window.utgifter.views.YearlyOverviewView extends Backbone.View
  template: JST['overview/yearly']
  render: ->
    $(@el).append(@template)
    @

  renderGraph: ->
    renderChartTo = $(@el).find("#chartContainer")
    result = utgifter.charts.dataGenerator(@collection.models, "yearly")
    new utgifter.charts.bar.BarChart(result.categories, result.series, renderChartTo)

