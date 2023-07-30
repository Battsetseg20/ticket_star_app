require 'net/http'
require 'uri'
# This helper is used to fetch images from the loremflickr.com website to seed the event_item object with an image
# This helper is used in the db/seeds.rb file
module ImageHelper
  def fetch_image(url)
    redirection_limit = 2
    base_url = 'https://loremflickr.com'
  
    redirection_limit.times do
      uri = URI.parse(url)
  
      raise "Invalid URL: #{url}" unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
  
      request = Net::HTTP::Get.new(uri)
  
      response = http.request(request)
  
      case response
      when Net::HTTPSuccess then
        return uri.to_s
      when Net::HTTPRedirection then
        url = response['location']
  
        # Check if the location is a relative URL
        # /cache/resized/65535_52638011356_5744d0c1ed_300_300_nofilter.jpg
        if url.start_with?('/')
          # Construct the absolute URL
          url = base_url + url
        end
      else
        response.error!
      end
    end
  
    raise "Too many HTTP redirects for URL: #{url}"
  end
end
