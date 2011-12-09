class window.utgifter.views.MonthlyOverviewView extends Backbone.View
  template: JST['overview/monthly']
  render: ->
    $(@el).append(@template)
    @

  renderGraph: ->
    renderChartTo = document.getElementById("chartContainer")
    result = utgifter.charts.dataGenerator(@collection.models, "monthly")
    new utgifter.charts.column.ColumnChart(result.categories, result.series, renderChartTo)

