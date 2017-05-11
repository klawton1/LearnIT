require 'dotenv/load'
require 'rest-client'
require 'json'
namespace :get_courses do

  desc "Set views to 0"
  task reset_views: :environment do
    Course.update_all("views = 0")
  end

  desc "Get all Courses"
  task all: [:coursera, :udacity, :udemy, :edx] do
  end

  desc "Put coursera courses into database"
  task coursera: :environment do
    starts = [0, 1000]
    starts.each do |start|
      res = RestClient.get "https://api.coursera.org/api/courses.v1?q=search&fields=id,name,photoUrl,s12nIds,description,workload,domainTypes,previewLink,primaryLanguages,specializations,certificates&limit=1000&start=#{start}"
      res = JSON.parse(res)
      res['elements'].each do |course|
        tech = false
        course['domainTypes'].each do |d|
          if (d['domainId'] == 'computer-science' || d['domainId'] == 'data-science') && course['primaryLanguages'].include?("en")
            tech = true
          end
        end
        if tech
          c = {}
          c[:category] = ""
          course['domainTypes'].each do |d|
            c[:category] = c[:category] + d['domainId'] + " " + d['subdomainId']
          end
          c[:header] = course['slug'].gsub('-', ' ')
          c[:class_id] = course['id']
          c[:title] = course['name']
          c[:description] = course['description']
          c[:short_desc] = course['description'][0..200] + "..."
          c[:image] = course['photoUrl']
          c[:course_url] = "https://www.coursera.org/learn/" + course['slug']
          if course["previewLink"]
            c[:preview_url] = course["previewLink"]
          end
          c[:duration] = course['workload']
          c[:provider] = 0
          if course['certificates'].empty?
            c[:has_cert] = false
          else
            c[:has_cert] = true
          end
          found = Course.find_by(class_id: c[:class_id])
          if !found
            Course.create(c)
          else
            found.update(c)
          end
        end
      end
    end
    Course.reindex
  end

  desc "Put udacity courses into database"
  task udacity: :environment do
    res = RestClient.get "https://www.udacity.com/public-api/v0/courses"
    res = JSON.parse(res)
    res['courses'].each do |course|
      c = {}
      c[:level] = course['level']
      c[:category] = course['subtitle']
      c[:header] = course['slug'].split("--")[0].gsub('-', ' ')
      c[:title] = course['title']
      c[:class_id] = course['key']
      c[:description] = course['expected_learning']
      c[:short_desc] = course['short_summary']
      if course['image'].empty?
        c[:image] = "https://in.udacity.com/assets/images/partners/logo_color_udacity.png?v=c37f67d7"
      else
        c[:image] = course['image']
      end
      c[:course_url] = course['homepage']
      unless course["teaser_video"]["youtube_url"].empty?
        c[:preview_url] = course["teaser_video"]["youtube_url"]
      end
      c[:duration] = course['expected_duration'].to_s + " " + course['expected_duration_unit']
      c[:provider] = 1
      if course['related_degree_keys'].empty?
        c[:has_cert] = false
      else
        c[:has_cert] = true
      end
      found = Course.find_by(class_id: c[:class_id])
      if !found
        Course.create(c)
      else
        found.update(c)
      end
    end
    Course.reindex
  end

  desc "Put Udemy courses into database"
  task udemy: :environment do
    (1..10).each do |i|
      res = RestClient.get "https://www.udemy.com/api-2.0/courses/?fields[course]=@all&page=#{i}&page_size=100", {:Authorization => ENV["UDEMY_KEY"]}
      res = JSON.parse(res)
      res['results'].each do |course|
        if (course['primary_category']['title'] == "Development" || course['primary_category']['title'] == "IT & Software") && course['is_published']
          c = {}
          c[:level] = course['instructional_level']
          c[:category] = course['primary_category']['title'] + " " + course['primary_subcategory']['title']
          c[:header] = course['published_title'].gsub('-', ' ')
          c[:title] = course['title']
          c[:class_id] = course['id']
          c[:description] = course['description']
          c[:short_desc] = course['headline']
          c[:image] = course['image_480x270']
          c[:course_url] = "https://www.udemy.com" + course['url']
          c[:duration] = course['content_info']
          c[:provider] = 2
          c[:has_cert] = course['has_certificate']
          found = Course.find_by(class_id: c[:class_id])
          if !found
            Course.create(c)
          else
            found.update(c)
          end
        end
      end
    end
    Course.reindex
  end

  desc "Put edX courses into database"
  task edx: :environment do
    res = RestClient.post 'https://api.edx.org/oauth2/v1/access_token', {grant_type: 'client_credentials', token_type: 'jwt', client_id: ENV['EDX_ID'], client_secret: ENV['EDX_SECRET']}
    res = JSON.parse(res)
    token = res['access_token']
    catalogs = RestClient.get "https://api.edx.org/catalog/v1/catalogs/", {:Authorization => "JWT #{token}"}
    catalogs = JSON.parse(catalogs)
    id = catalogs['results'][0]['id']
    courses = RestClient.get "https://api.edx.org/catalog/v1/catalogs/#{id}/courses", {:Authorization => "JWT #{token}"}
    courses = JSON.parse(courses)
    edx_courses(courses)
    while courses['next'] do
      courses = RestClient.get courses['next'], {:Authorization => "JWT #{token}"}
      courses = JSON.parse(courses)
      edx_courses(courses)
    end
  end
end

def edx_courses courses
  courses['results'].each do |course|
    c = {}
    c[:level] = course['level_type']
    c[:category] = course['subjects'].map{|s| s['name']}.join(" ")
    c[:header] = course['title'][0..30]
    c[:title] = course['title']
    c[:class_id] = course['key']
    c[:description] = course['full_description']
    c[:short_desc] = course['short_description']
    if course['image']
      c[:image] = course['image']['src']
    end
    c[:course_url] = "https://www.edx.org/course?search_query=" + c[:title]
    c[:provider] = 3
    if course['video']
      c[:preview_url] = course['video']['src']
    end
    found = Course.find_by(class_id: c[:class_id])
    if !found
      Course.create(c)
    else
      found.update(c)
    end
  end
end
