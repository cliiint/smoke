require 'uri'
require 'net/http'

class PurpleClient
  def initialize(read, write = nil)
    @read_api_key = read
    @write_api_key = write
  end

  def get_reading(user)
    sensor = Rails.application.credentials&.purple[:default_sensor_index]
    raise 'Application credential(s) are missing' unless sensor && @read_api_key

    uri = URI("https://api.purpleair.com/v1/sensors/#{sensor}")
    req = Net::HTTP::Get.new(uri)
    req['X-API-Key'] = @read_api_key

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) { |http|
      http.request(req)
    }

    if res.is_a?(Net::HTTPSuccess)
      json = JSON.parse(res.body)
      pm25 = json['sensor']['pm2.5']
      aqi = Aqi::aqi_from_pm25(pm25)

      begin
        Reading.create!(user: user, aqi: aqi)
      rescue => e
        Rails.logger.warn('Unable to save Reading: ' + e.message)
      end
    end
  end
end

PURPLE = PurpleClient.new(Rails.application.credentials.purple[:read_api_key])