$(document).on 'turbolinks:load', ->
  $('#importer-select').on 'change', ->
    if @.value != ''
      $('#data-row').removeClass 'hidden'
      $.post '/phones/brands', { importer: @.value }, (data) =>
        if data != undefined
          $('#brand-select').html ''
          for brand in data
            $('#brand-select').append $('<option>', value: brand, text: brand)
      , 'JSON'

  $('#brand-select').on 'change', ->
    importer = $("#importer-select option:selected" ).text()
    $.post '/phones/models', { brand: @.value, importer: importer }, (data) =>
      if data != undefined
        $('#model-select').html ''
        for model in data
          $('#model-select').append $('<option>', value: model, text: model)
    , 'JSON'

  $('#model-select').on 'change', ->
    importer = $("#importer-select option:selected" ).text()
    $.post '/phones/detail', { model: @.value, importer: importer }, (data) =>
      if data != undefined
        $('#phone-detail').html(data)
