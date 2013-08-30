$ -> 
  logStart = null
  intervals = []
  poll = (url) ->
    $.ajax(url, {
      data: {
        time: (new Date()).getTime()
      }
    })

  pollLog = (url) ->
    $.ajax(url, {
      data: {
        offset: logStart,
        time: (new Date()).getTime()
      },
      success: (data, status, xhr) ->
        log = $("#log")
        log.append(data).scrollTop(log.prop("scrollHeight")) if data != ""
        log.removeClass('uncompleted') if xhr.getResponseHeader('X-Log-Complete')
    })

  stopIntervals = () ->
    clearInterval i for i in intervals
    intervals = []

  setupPollingContent = () ->
    stopIntervals()
    $("*[data-poll]").each (i, el) ->
      el = $(el)
      delay = el.attr('data-poll-delay') || 5000
      intervals.push setInterval () ->
        poll el.attr('data-poll')
      , delay
    $("*[data-poll-log").each (i, el) ->
      el = $(el)
      delay = el.attr('data-poll-delay') || 5000
      logStart = el.attr('data-poll-log-start')
      intervals.push setInterval () ->
        pollLog el.attr('data-poll-log')
      , delay if logStart

  $(document).bind "page:load", setupPollingContent
  setupPollingContent()