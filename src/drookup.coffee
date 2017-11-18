# Description
#   A hubot script that allows hubot to do some useful lookups on various Drupal topics
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
#   Adam Boros <hunaboros@gmail.com>

module.exports = (robot) ->
  base_url = "https://api.drupal.org"
  api_url = "#{base_url}/api/drupal"
  api_version = "8.4.x"
  robot.hear /^dapi (.*)/i, (res) ->
    keyword = res.match[1]
    search_url = "#{api_url}/#{api_version}/search/#{keyword}"
    robot.http(search_url)
      .get() (error, response, body) ->
        code = response.statusCode
        if error
          res.send "An error occured: #{error}"
          return
        if code isnt 200
          if code is 302
            res.send response.headers.location
            return
          res.send "search_url: #{search_url}"
          res.send "Response code: #{code}"
          return
        $ = require('cheerio').load(body)
        view_empty = $('#block-system-main .view-empty').text()
        top_hit_uri = $('#block-system-main .view-api-search .views-row-first .views-field-file-name a').attr('href')
        if top_hit_uri is undefined
          res.send("#{view_empty}")
          return
        res.send("Top hit: #{base_url}#{top_hit_uri}")
