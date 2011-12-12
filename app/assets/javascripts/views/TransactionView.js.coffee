class window.utgifter.views.TransactionView extends Backbone.View
  template: JST['transactions/show']
  tagName: 'tr'

  initialize: ->
    @model.bind("change", @highlightForm)

  events: ->
    "click form a.delete-transaction"         : "deleteTransaction"

  render: ->
    $(@el).html(@template(@model))
    @makeEditable()
    @

  highlightForm: =>
    $(@el).effect('highlight')

  deleteTransaction: (evt) =>
    evt.preventDefault()
    row = $(@el)
    @model.destroy({ success: ->
      row.hide('slow', -> $(@).remove())
    })

  makeEditable: ->
    model = @model
    $(@el).find('td').editable( (value, settings) ->
      type = $(this).attr('data-name')
      obj = {}
      obj[type] = value
      model.save(obj)
      value

    {
      indicator: 'Lagrer...'
      tooltip: 'Klikk for å editere'
    }
    )
