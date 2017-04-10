require 'rest-client'
require 'JSON'
namespace :get_courses do
  desc "Put coursera courses into database"
  task coursera: :environment do
    res = RestClient.get "https://api.coursera.org/api/courses.v1?q=search&fields=id,name,photoUrl,s12nIds,description,workload,domainTypes,previewLink,primaryLanguages,specializations,
    certificates&limit=200&start=100"
    res = JSON.parse(res)
    res['elements'].each do |course|
      course['domainTypes'].each do |d|
        if (d['domainId'] == 'computer-science' || d['domainId'] == 'data-science') && course['primaryLanguages'].include?("en")
          c = {}
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

          found = Course.where(class_id: c[:class_id])
          if found.empty?
            Course.create(c)
          else
            found[0].update(c)
          end
        end
      end
    Course.reindex
    end
  end
  desc "Put udacity courses into database"
  task udacity: :environment do
    res = RestClient.get "https://www.udacity.com/public-api/v0/courses"
    res = JSON.parse(res)
    res['courses'].each do |course|
      c = {}
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

      found = Course.where(class_id: c[:class_id])
      if found.empty?
        Course.create(c)
      else
        found[0].update(c)
      end
    end
    Course.reindex
  end
end
