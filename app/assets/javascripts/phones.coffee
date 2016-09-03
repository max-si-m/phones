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

  $('#search-form').on 'submit', (e) ->
    e.preventDefault()
    importer = $("#importer-select option:selected" ).text()
    query = $("#q").val()
    $.post '/phones/search', { q: query, importer: importer }, (data) =>
      $('#search-btn').removeAttr('data-disable-with').removeAttr('disabled')
      if data.error != "undefined"
        return $('#phone-detail').html("<h1>#{data.error}</h1>")
      else
        return $('#phone-detail').html(data)

