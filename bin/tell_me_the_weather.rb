#!/usr/bin/env ruby
require 'festivaltts4r'
require 'curb'
require 'json'
require 'ruby-units'
require 'open-uri'

class Weather

  # Constructor is going to find zip code by looking up public IP address.
  def initialize
    # Need to rescue in case the internet connection doesn't work
    begin
      @coordinates = JSON.parse(open("http://ip-api.com/json/?fields=lat,lon").read)
	  if @coordinates['lat'].nil? or @coordinates['lon'].nil?
		p "Sorry, I don't know where you are"
		exit
	  end
    rescue
      p "Something went wrong, and you're likely not connected to the internet. Please make sure you're connected and try again."
      p "Exiting..."
      exit
    end
  end

  def get_the_weather
    weather_data = JSON.parse(Curl.get("api.openweathermap.org/data/2.5/weather?lat=#{@coordinates['lat']}&lon=#{@coordinates['lon']}&APPID=0fc1d8810cd59b15060edc06d5fd58c8").body_str)
    # Get the temperature and slice off the ending part of the string that gets returned by ruby units.
    temp_in_farenheit = Unit("#{weather_data["main"]["temp"]} tempK").convert_to("tempF").to_s[0..-7].to_f.round
    "It's currently #{temp_in_farenheit} degrees in #{weather_data["name"]}"
  end
end

Weather.new.get_the_weather.to_speech
