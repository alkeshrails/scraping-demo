require "watir-webdriver"
require 'csv'


browser = Watir::Browser.new

#Scriping data from www.indeed.com

browser.goto "http://www.indeed.com/jobs?q=%22Salesforce%22&l=Austin%2C+TX&sort=date"

num_pages = (browser.div(id: "searchCount").text.gsub("Jobs 1 to 10 of ", "").to_i / 10.to_f).ceil rescue nil
num_pages ||= 1

indeed_data = []
1.upto(num_pages) do |k|
  div = browser.divs(class: "row  result").size
  (0..(div-1)).each do |n|
    indeed_data << browser.divs(class: "row  result")[n].span(class: "company").text
  end
  sleep(3)
  browser.div(class: "pagination").link(:text, "#{k+1}").click if k != num_pages
end

p indeed_data

file = "indeed_data.csv"
company_list = indeed_data.flatten.reject! { |c| c.empty? }   
CSV.open(file, 'w' ) do |writer|
  company_list.each do |s|
    writer << [s]
  end
end
