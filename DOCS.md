# strava-api-v3

[![Build Status](https://travis-ci.org/jaredholdcroft/strava-api-v3.svg?branch=master)](https://travis-ci.org/jaredholdcroft/strava-api-v3)
[![Maintainability](https://api.codeclimate.com/v1/badges/8ee75b7f62d2c2962b1b/maintainability)](https://codeclimate.com/github/jaredholdcroft/strava-api-v3/maintainability)

This gem provides a wrapper around the Strava API V3 - [http://strava.github.io/api/](http://strava.github.io/api/)

## Install

gem install 'strava-api-v3'

## Create a client

At this point you will need to have the user authorise your application using OAuth2.

```ruby
require 'strava/api/v3'

@client = Strava::Api::V3::Client.new(:access_token => "MY_ACCESS_TOKEN")
```

## Call API methods

### Activity

Each method returns a JSON object - see [http://strava.github.io/api/v3/activities/](http://strava.github.io/api/v3/activities/) for more info

```ruby

# create a manually entered activity (require write permissions)
@client.create_an_activity(name: 'Manually Created Activity', type: 'run', start_date_local: '2016-10-02T09:05:05Z', elapsed_time: 600)

@client.retrieve_an_activity(:activity_id)

@client.update_an_activity(:activity_id, description: 'New Description') # update an activity (require write permissions)

@client.list_athlete_activities

@client.list_friends_activities

@client.list_related_activities(:activity_id) # fetch activities that were matched as "with this group"

@client.list_activity_zones(:activity_id) # fetch heartrate and power zones of an activity (require a premium account subscription)

@client.list_activity_laps(:activity_id)

```

### Activity extras

Each method returns a JSON object of respective type - see
[https://strava.github.io/api/v3/comments/](https://strava.github.io/api/v3/comments/),
[https://strava.github.io/api/v3/kudos/](https://strava.github.io/api/v3/kudos/) and
[https://strava.github.io/api/v3/activity_photos/](https://strava.github.io/api/v3/activity_photos/) for more info

```ruby

@client.list_activity_comments(:activity_id)

@client.list_activity_kudos(:activity_id)

@client.list_activity_photos(:activity_id) # only if you created the activity...

```

### Athlete

Each method returns a JSON object - see [http://strava.github.io/api/v3/athlete/](http://strava.github.io/api/v3/athlete/) for more info

```ruby

@client.retrieve_current_athlete # fetch the authenticated athlete

@client.retrieve_another_athlete(:athlete_id) # fetch another athlete by id

@client.update_current_athlete(city: 'Lisbon') # update the authenticated athlete (require write permissions)

@client.retrieve_current_athlete_zones # fetch zone information of the authenticated athlete

@client.totals_and_stats(:athlete_id) # fetch totals and stats for an athlete by id

@client.list_athlete_segment_efforts(:athlete_id) # fetch K/QOMs/CRs for an athlete by id

```

### Athlete extras

Each method returns a JSON object of respective type - see
[https://strava.github.io/api/v3/follow/](https://strava.github.io/api/v3/follow/) for more info

```ruby

@client.list_athlete_friends

@client.list_specific_athlete_friends(:athlete_id)

@client.list_athlete_followers

@client.list_specific_athlete_followers(:athlete_id)

@client.list_both_following_athletes(:athlete_id)

```

### Club

Each method returns a JSON object - see [https://strava.github.io/api/v3/clubs/](https://strava.github.io/api/v3/clubs/) for more info

```ruby

@client.retrieve_a_club(:club_id)

@client.list_club_announcements(:club_id)

@client.list_athlete_clubs

@client.list_club_members(:club_id)

@client.list_club_admins(:club_id)

@client.list_club_activities(:club_id)

@client.join_a_club(:club_id) # join a club on behalf of the authenticated athlete (require write permissions)

@client.leave_a_club(:club_id) # leave a club on behalf of the authenticated user (require write permissions)

```

### Club Group Event

Each method returns a JSON object - see [https://strava.github.io/api/v3/club_group_events/](https://strava.github.io/api/v3/club_group_events/) for more info

```ruby

@client.retrieve_a_group_event(:club_event_id)

@client.list_club_group_events(:club_event_id)

@client.join_a_group_event(:club_event_id) # join a group event on behalf of the authenticated athlete (require write permissions)

@client.leave_a_group_event(:club_event_id) # leave a group event on behalf of the authenticated athlete (require write permissions)

@client.delete_a_group_event(:club_event_id) # delete (and cancel) an event, which must be editable by the authenticating user

@client.list_joined_athletes(:club_event_id)

```

### Gear

Each method returns a JSON object - see [http://strava.github.io/api/v3/gear/](http://strava.github.io/api/v3/gear/) for more info

```ruby

@client.retrieve_gear(:some_id)

```

### Route

Each method returns a JSON object - see [http://strava.github.io/api/v3/routes/](http://strava.github.io/api/v3/routes/) for more info

```ruby

@client.retrieve_a_route(:some_id)

@client.list_athlete_routes

```

### Running Races

Each method returns a JSON object - see [https://strava.github.io/api/v3/running_races/](https://strava.github.io/api/v3/running_races/) for more info

```ruby

@client.list_running_races

@client.retrieve_running_race_details(:race_id)

```

### Segment

Each method returns a JSON object - see [http://strava.github.io/api/v3/segments/](http://strava.github.io/api/v3/segments/) for more info

```ruby

@client.retrieve_a_segment(:segment_id)

@client.list_starred_segment

@client.star_a_segment(:segment_id, starred: true) # star a segment on behalf of the current authenticated user (require write permissions)

@client.segment_leaderboards(:segment_id)

@client.segment_explorer

@client.segment_list_efforts(:segment_id)

```

### Segment Effort

Each method returns a JSON object - see [http://strava.github.io/api/v3/efforts/](http://strava.github.io/api/v3/efforts/) for more info

```ruby

@client.retrieve_a_segment_effort(:some_id)

```

### Stream

Each method returns a JSON object - see [http://strava.github.io/api/v3/streams/](http://strava.github.io/api/v3/streams/) for more info

```ruby

@client.retrieve_activity_streams(:activity_id)

@client.retrieve_effort_streams(:segment_effort_id)

@client.retrieve_route_streams(:route_id)

@client.retrieve_segment_streams(:segment_id)


```

### Upload

Support for uploading activity files (FIT, TCX and GPX file types are supported by Strava. See [https://strava.github.io/api/v3/uploads/](https://strava.github.io/api/v3/uploads/) for more info

```ruby

# Prepare options for upload
options = {}
options[:activity_type] = 'ride'
options[:data_type] = 'tcx'

# Open the file from the file systems
options[:file] = File.new('myfile.tcx')

# Submit upload and get upload ID
# Require write permission
status = @client.upload_an_activity(options)
upload_id = status['id']

# Re-poll for status
status = @client.retrieve_upload_status(upload_id)

```

### Authentication

Retrieve user token and information (athlete). See [http://strava.github.io/api/v3/oauth](http://strava.github.io/api/v3/oauth) for more info

```ruby

access_information = Strava::Api::V3::Auth.retrieve_access('client_id', 'client_secret', 'code')
access_token = access_information['access_token']
athlete_information = access_information['athlete']

```


## Contributors

* [Jared Holdcroft](https://github.com/jaredholdcroft)
* [James Chevalier](https://github.com/JamesChevalier)
* [Yi Zeng](https://github.com/yizeng)
