require 'open-uri'
require 'nokogiri'



def scrapeAmazon(url)
    # Pull in the page
    reviews = []
    doc = Nokogiri::HTML(open(url))
    results = doc.css("div > span > div > div.a-expander-content.a-expander-partial-collapse-content")
    results.each do |r|
      reviews.push(r.text)
    end
    return reviews
  end


print(scrapeAmazon("https://www.amazon.com/Neutrogena-Therapeutic-Original-Dandruff-Treatment/dp/B0009KN8UA/ref=sr_1_1?ie=UTF8&qid=1501120105&sr=8-1-spons&keywords=t%2Bgel%2Bshampoo&th=1"))
