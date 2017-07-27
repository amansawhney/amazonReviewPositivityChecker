require 'open-uri'
require 'nokogiri'
require 'sentimental'
require 'pragmatic_segmenter'

def scrapeYelp(url, queryString)

  analyzer = Sentimental.new
  analyzer.load_defaults
  analyzer.threshold = 0.1
  # Pull in the page
  reviews = []
  doc = Nokogiri::HTML(open(url,  "User-Agent" => "Ruby/#{RUBY_VERSION}",
  "From" => "foo@bar.invalid",
  "Referer" => "http://www.ruby-lang.org/"))
  results = doc.css("#super-container > div > div > div.column.column-alpha.main-section > div > div.feed > div.review-list > ul > li > div > div.review-wrapper > div.review-content > p")
  results.each do |r|
    if(r.text.downcase.include?(queryString.downcase))
      ps = PragmaticSegmenter::Segmenter.new(text: r.text)
      sentences = ps.segment
      scores = []
      sentences.each do |s|
        scores.push(analyzer.score s)
      end
      reviews.push(scores.inject{ |sum, el| sum + el }.to_f)
      reviews.push(r.text)
    end
  end
  return reviews
end

File.write('./reviewData.txt', scrapeYelp("https://www.yelp.com/biz/peaches-hothouse-brooklyn", "Fried Chicken").to_s)
#   File.open(f, 'w') { |file| file.write(scrapeAmazon("https://www.amazon.com/Neutrogena-Therapeutic-Original-Dandruff-Treatment/dp/B0009KN8UA/ref=sr_1_1?ie=UTF8&qid=1501120105&sr=8-1-spons&keywords=t%2Bgel%2Bshampoo&th=1")
# ) }
