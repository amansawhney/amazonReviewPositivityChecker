require 'open-uri'
require 'nokogiri'
require 'sentimental'
require 'pragmatic_segmenter'
require "csv"
require 'spreadsheet'


def scrapeAmazon(url)

  analyzer = Sentimental.new
  analyzer.load_defaults
  analyzer.threshold = 0.1
    # Pull in the page
    reviews = []
    doc = Nokogiri::HTML(open(url,  "User-Agent" => "Ruby/#{RUBY_VERSION}",
    "From" => "foo@bar.invalid",
    "Referer" => "http://www.ruby-lang.org/"))
    results = doc.css("div > span > div > div.a-expander-content.a-expander-partial-collapse-content")
    results.each do |r|
      ps = PragmaticSegmenter::Segmenter.new(text: r.text)
      sentences = ps.segment
      scores = []
      sentences.each do |s|
        scores.push(analyzer.score s)
      end
      reviewPair = []
      reviewPair.push(scores.inject{ |sum, el| sum + el }.to_f)
      reviewPair.push(r.text)
      reviews.push(reviewPair)
    end
    return reviews
  end


  File.write('./reviewData.txt', scrapeAmazon("https://www.amazon.com/Steal-This-Book-Abbie-Hoffman/dp/156858217X/ref=sr_1_1?ie=UTF8&qid=1501125005&sr=8-1&keywords=steal+this+book").to_s)
#   File.open(f, 'w') { |file| file.write(scrapeAmazon("https://www.amazon.com/Neutrogena-Therapeutic-Original-Dandruff-Treatment/dp/B0009KN8UA/ref=sr_1_1?ie=UTF8&qid=1501120105&sr=8-1-spons&keywords=t%2Bgel%2Bshampoo&th=1")
# ) }
