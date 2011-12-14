class utgifter.views.NewTransactionGroupView extends Backbone.View
  collection: utgifter.collections.transactionGroupCollection

  events: ->
    "keypress input"              : 'saveOnEnter'

  render: ->
    model = new utgifter.models.TransactionGroup()
    form = new Backbone.Form({ model: model }).render().el
    $(@el).html(form)
    @

  saveOnEnter: (evt) =>
    if evt.keyCode == 13
      fieldset = $(evt.target).closest("fieldset")
      fieldset.effect('highlight')
      @collection.create({
        title: fieldset.find('#title').val()
        regex: fieldset.find('#regex').val()
        use_as_skiplist: fieldset.find("#use_as_skiplist").is(':checked')
      })
