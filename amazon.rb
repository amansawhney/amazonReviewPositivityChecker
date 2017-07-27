require 'open-uri'
require 'nokogiri'
require 'sentimental'







def scrapeAmazon(url)
  analyzer = Sentimental.new
  analyzer.load_defaults
  analyzer.threshold = 0.1
    # Pull in the page
    reviews = []
    doc = Nokogiri::HTML(open(url))
    results = doc.css("div > span > div > div.a-expander-content.a-expander-partial-collapse-content")
    results.each do |r|
      reviews.push(analyzer.score r.text)
      reviews.push(r.text)
    end
    return reviews
  end

  File.write('./reviewData.txt', scrapeAmazon("https://www.amazon.com/gp/product/156858217X/ref=s9u_simh_gw_i1?ie=UTF8&fpl=fresh&pd_rd_i=156858217X&pd_rd_r=2DWMW4K9CAWA7B0951X0&pd_rd_w=G9Ykn&pd_rd_wg=knYTh&pf_rd_m=ATVPDKIKX0DER&pf_rd_s=&pf_rd_r=DKG0RJB70APSWKWBAMP5&pf_rd_t=36701&pf_rd_p=f719e185-4825-42a4-9507-9df1a19229d6&pf_rd_i=desktop").to_s)
#   File.open(f, 'w') { |file| file.write(scrapeAmazon("https://www.amazon.com/Neutrogena-Therapeutic-Original-Dandruff-Treatment/dp/B0009KN8UA/ref=sr_1_1?ie=UTF8&qid=1501120105&sr=8-1-spons&keywords=t%2Bgel%2Bshampoo&th=1")
# ) }
