require "watir-webdriver"
require 'csv'


browser = Watir::Browser.new

# Scriping data from www.linkedin.com

browser.goto "https://www.linkedin.com/uas/login"
browser.text_field(name: "session_key").set "put email id"
browser.text_field(name: "session_password").set  "password"
browser.button(name: "signin").click
sleep(3)
browser.goto "https://www.linkedin.com/vsearch/j?keywords=Salesforce&openAdvancedForm=true&locationType=Y&rsid=331079161431413015395&orig=MDYS"

num_pages = (browser.div(class: "search-info").p.strong.text.gsub(",","" ).to_i / 25.to_f).ceil rescue nil
num_pages ||= 1

linkedin_data = []
1.upto(num_pages) do |k|
  div = browser.divs(class: "description").size
  (0..(div-1)).each do |n|
    linkedin_data << browser.divs(class: "description")[n].text
  end
  browser.ul(class: "pagination").link(:text, "#{k+1}").click if k != num_pages
 sleep(6)
end

p linkedin_data

file = "linkedin_data.csv"
company_list = linkedin_data.flatten   
CSV.open(file, 'w' ) do |writer|
  company_list.each do |s|
    writer << [s]
  end
end
