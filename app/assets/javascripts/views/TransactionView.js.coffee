class utgifter.views.TransactionView extends Backbone.View
  template: JST['transactions/show']
  tagName: 'tr'

  initialize: ->
    @model.bind("change", @highlightForm)

  events: ->
    "click a.delete-transaction"         : "deleteTransaction"

  render: ->
    $(@el).html(@template({ model : @model }))
    @makeEditable()
    @

  highlightForm: =>
    $(@el).effect('highlight')

  deleteTransaction: (evt) =>
    evt.preventDefault()
    row = $(@el)
    collection = @model.collection
    cid = @model.cid
    @model.destroy({
      success: =>
        row.hide('slow', -> $(@).remove())
        collection.remove(cid)
    })

  makeEditable: ->
    model = @model
    $(@el).find('td[data-editable=true]').editable( (value, settings) ->
      type = $(this).attr('data-name')
      obj = {}

      # convert to UTC before sending to server
      if type == 'time'
        obj[type] = new Date(value + " 00:00").toUTCString()
      else
        obj[type] = value

      model.save(obj)

      value
    {
      indicator: 'Lagrer...'
      tooltip: 'Klikk for å editere'
    }
    )

  leave: ->
    $(@el).find('td[data-editable=true]').editable('destroy')
    @model.unbind("change", @highlightForm)
