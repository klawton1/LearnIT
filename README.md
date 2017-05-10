#  Welcome To Learn IT!

This site lets users search through course data from Coursera, Udacity, Udemy, and edX to find the course they are looking for.

## Ruby Gems Used
* bcrypt
* bootstrap-sass
* friendly_id
* searchkick
* elasticsearch
* dotenv-rails
* rest-client

## Technologies
* HTML
* CSS
* Javascript
* Ruby on Rails
* jQuery
* Bootstrap
*PostgreSQL

## Getting Started 
* First include all of the gems listed above in gemfile
* To add gems to app run: `bundle install` 
* Add all migrations by running: `rails db:migrate`

## Setting up ENV variables
* the api's for Udemy, and edX all require a token or key to get access to their data. So before continuing any further make sure to request and get those key as you will need them for the rake task to seed your database
* next store the keys as ENV variables in your rails app by running the following commands:
* `touch .env` - where the keys will be stored
open the .env file and add your keys with these names:
* `EDX_ID = "YOUR_EDX_ID"`
* `EDX_SECRET = "YOUR_EDX_SECRET"`
* `UDEMY_KEY = "YOUR_UDEMY_KEY"` - this is the authorization key you get from a request with your ID and Secret. Find this quickly here: https://www.udemy.com/developers/methods/get-coursereviews-list

And that's it! now you have your ENV variables saved and are ready to run any and all rake tasks.

## Seed Database with Courses

* To get all courses run:
`rake get_courses:all`

* To get courses for a specific provider(ex: coursera) run:
`rake get_courses:coursera`
simply replace coursera with udacity, udemy, or edx to get courses from that provider.

## HAVE FUN AND GIVE FEEDBACK!
