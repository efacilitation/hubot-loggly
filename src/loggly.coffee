# Description
#   A hubot script to query the Loggly API
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   efa <team@efa-gmbh.com>
Util = require 'util'


makeLogglyRequest = (robot, path, callback) ->
  robot.http "https://#{process.env.HUBOT_LOGGLY_ACCOUNT}.loggly.com#{path}"
  .header 'Accept', 'application/json'
  .auth process.env.HUBOT_LOGGLY_USERNAME, process.env.HUBOT_LOGGLY_PASSWORD
  .get() (error, response, body) ->
    try
      callback JSON.parse body
    catch error
      callback {}


getLogglyEvents = (robot, from, to, callback) ->
  makeLogglyRequest robot, "/apiv2/search?q=*&from=#{from}&until=#{to}&size=50", (searchRequestData) ->
    makeLogglyRequest robot, "/apiv2/events?rsid=#{searchRequestData.rsid.id}", (eventData) ->
      callback eventData


module.exports = (robot) ->

  robot.hear /loggly get from ([^\s]+?) until ([^\s]+?)$/, (response) ->
    getLogglyEvents robot, response.match[1], response.match[2], (eventData) ->
      eventData.events.forEach (event) ->
        response.send "New Loggly event: #{Util.inspect event}"


  intervalId = null
  robot.hear /loggly get every ([^\s]+?) seconds/, (response) ->
    seconds = response.match[1]
    intervalTimeoutMs = seconds * 1000
    intervalId = setInterval ->
      getLogglyEvents robot, "-#{seconds}s", 'now', (eventData) ->
        eventData.events.forEach (event) ->
          response.send "New Loggly event: #{Util.inspect event}"
    , intervalTimeoutMs
    response.send "Loggly interval activated for every #{intervalTimeoutMs}ms"


  robot.hear /loggly deactivate interval/, (response) ->
    clearInterval intervalId
    response.send 'Loggly interval deactivated'
