require 'rest-client'
require 'JSON'
namespace :get_courses do
  desc "Put Courses into database"
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
          c[:image] = course['photoUrl']
          c[:course_url] = "https://www.coursera.org/learn/" + course['slug']
          if course["previewLink"]
            c[:preview_url] = course["previewLink"]
          end
          c[:duration] = course['workload']
          c[:provider] = 0
          unless course['certificates'].empty?
            c[:has_cert] = true
          end
          Course.create(c)
        end
      end
    end
  end

  # task udacity: :environment do 
  #   res = RestClient.get "https://api.coursera.org/api/courses.v1?q=search&fields=name,photoUrl,s12nIds,description,workload,domainTypes,previewLink,primaryLanguages,specializations,
  #   certificates&limit=200&start=100"
  #   res = JSON.parse(res)
  # end

end
