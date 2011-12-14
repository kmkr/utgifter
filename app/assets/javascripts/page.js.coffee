$(->
  $('nav a').click(->
    $('nav a').removeClass('active')
    $(@).addClass('active')
  )

  $.tools.dateinput.localize("no",  {
    months:        'januar,februar,mars,april,mai,juni,juli,august,september,oktober,november,desember'
    shortMonths:   'jan,feb,mar,apr,mai,jun,jul,aug,sep,okt,nov,des'
    days:          'mandag,tirsdag,onsdag,torsdag,fredag,lørdag,søndag'
    shortDays:     'man,tir,ons,tor,fre,lør,søn'
  })

  $.tools.validator.localize("no", {
    '*'           : 'Ugyldig verdi'
    ':email'      : 'Skriv inn en gyldig e-postadresse'
    ':number'     : 'Skriv inn et tall'
    '[max]'       : 'Skriv inn en verdi mindre enn $1'
    '[min]'       : 'Skriv inn en verdi mer enn $1'
    '[required]'  : 'Dette feltet er påkrevd'
  })

)
