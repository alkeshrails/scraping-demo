require "watir-webdriver"
require 'csv'


browser = Watir::Browser.new

#Scriping data from www.dice.com  

browser.goto "https://www.dice.com/jobs/q-%22salesforce%22-l-Torrance%2C+CA-radius-30-startPage-1-limit-30-jobs.html"

num_pages = (browser.h4(class: "posiCount").spans[1].text.gsub(",","" ).to_i / 30.to_f).ceil rescue nil
num_pages ||= 1

dice_data = []
1.upto(num_pages) do |k|
  div = browser.divs(class: "serp-result-content").size
  (0..(div-1)).each do |n|
    dice_data << browser.divs(class: "serp-result-content")[n].li(class: "employer").text
  end
  sleep(3)
  browser.div(id: "dice_paging_btm").link(:text, "#{k+1}").click if k != num_pages
end

p dice_data

file = "dice_data.csv"
company_list = dice_data.flatten   
CSV.open(file, 'w' ) do |writer|
  company_list.each do |s|
    writer << [s]
  end
end
