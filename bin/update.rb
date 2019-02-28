require "twitter"
require "nokogiri"
require "httparty"

twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = "LA35TBysTI3JBW2W7etV1RHqX"
  config.consumer_secret     = "2DmCYKHDgiZGYCK0joNYDndiWrQrDrzWIw3MJHQrOfOMbEVo4F"
  config.access_token        = "1064843846234849280-QWNX3DcJqFSe3yhxNJHkx2UsnZnaUQ"
  config.access_token_secret = "kmBEUU94kjpBxGTgHP3kQlniP9HVobajjsp0zLsDYL0Ey"
end

rss = HTTParty.get("https://iso.500px.com/feed/")
doc = Nokogiri::XML(rss)

latest_tweets = twitter.user_timeline("nordweglife")

previous_links = latest_tweets.map do |tweet|
  if tweet.urls.any?
    tweet.urls[0].expanded_url.to_s
  end
end

number = 0
doc.css("item").take(5).each do |item|
  title = item.css("title").text
  link  = item.css("link").text

  unless previous_links.include?(link)
    twitter.update("#{title} #{link}")
    puts "Item #{number} posted!"
    number += 1
  end
end
