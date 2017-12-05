# Description
#   A hubot script that allows hubot to do some useful lookups on various Drupal topics
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   dapi [keywords] - Performs search on api.drupal.org
#
# Notes:
#   Drupal rocks!
#
# Author:
#   Adam Boros <hunaboros@gmail.com>

module.exports = (robot) ->
  base_url = "https://api.drupal.org"
  api_url = "#{base_url}/api/drupal"
  # find out latest api at: https://www.drupal.org/api-d7/node.json?type=project_release&field_release_project=3060&limit=1&sort=nid&direction=DESC
  api_version = "8.4.x"

  # Do an api.drupal.org lookup
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
            # Jackpot, direct hit!
            res.send "Direct hit: #{response.headers.location}"
            return
          # Response codes other than 200 or 302
          res.send "search_url: #{search_url}"
          res.send "Response code: #{code}"
          return
        # Scrape the search results page
        $ = require('cheerio').load(body)
        view_empty = $('#block-system-main .view-empty').text()
        top_hit_uri = $('#block-system-main .view-api-search .views-row-first .views-field-file-name a').attr('href')
        if top_hit_uri is undefined
          # No results found
          res.send("#{view_empty}")
          return
        res.send("Top hit: #{base_url}#{top_hit_uri}")
  robot.hear /^dp ([a-z_]*)/i, (res) ->
    machine_name = res.match[1]
    search_url = "https://www.drupal.org/api-d7/node.json"
    query =
      field_project_machine_name: machine_name
    robot.http(search_url)
      .query(query)
      .get() (error, response, body) ->
        code = response.statusCode
        if error
          res.send "An error occured: #{error}"
          return
        if code isnt 200
          res.send "Project: #{machine_name} returned #{code}"
          return
        json_data = JSON.parse body
        project_data = json_data['list'][0]
        if project_data is undefined
          res.send "No project found for machine name: #{machine_name}"
          return
        project_url = "https://www.drupal.org/project/#{project_data.field_project_machine_name}"
        project_created = new Date(Number(project_data.created)).getFullYear()
        res.send "#{project_data.title} - #{project_data.field_download_count} downloads since #{project_created} | #{Number(project_data.created)} #{project_url}"
