define ['jquery'],($)->
  htmlEncode: (value)->
    $('div/>').text(value).html()

  htmlDecode: (value)->
    $('<div/>').html(value).text()