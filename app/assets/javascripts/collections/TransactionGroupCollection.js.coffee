class utgifter.collections.TransactionGroupCollection extends Backbone.Collection
  model: utgifter.models.TransactionGroup
  url: "/transaction_groups"

  onlySkiplists: ->
    @filter((transactionGroup)-> transactionGroup.get('use_as_skiplist'))

  noSkiplists: ->
    @filter((transactionGroup)-> not transactionGroup.get('use_as_skiplist'))
