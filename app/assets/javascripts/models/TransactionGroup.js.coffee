class utgifter.models.TransactionGroup extends Backbone.Model
  schema:
    title: { validators: ['required'], title: 'Tittel' }
    regex: { validators: ['required'], title: 'Søketekst' }
    'use_as_skiplist': { type: 'Checkbox', title: 'Bruk som skiplist?' }
