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
    catch
      callback {}

module.exports = (robot) ->

  robot.hear /loggly get from ([^\s]+?) until ([^\s]+?)$/, (response) ->
    makeLogglyRequest robot, "/apiv2/search?q=*&from=#{response.match[1]}&until=#{response.match[2]}&size=50", (searchRequestData) ->
      makeLogglyRequest robot, "/apiv2/events?rsid=#{searchRequestData.rsid.id}", (eventData) ->
        eventData.events.forEach (event) ->
          response.send "New Loggly event: #{Util.inspect event}"
