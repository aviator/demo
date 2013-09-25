#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'aviator'
require 'pp'

session = Aviator::Session.new(
            config_file: Pathname.new(__FILE__).join('../../aviator.yml').expand_path,
            environment: :demo,
            log_file:    Pathname.new(__FILE__).join('../../aviator.log').expand_path
          )
 
session.authenticate
 
compute = session.compute_service


# Get a flavor

puts "Retrieving flavors..."

response = compute.request(:list_flavors)

if response.status != 200
  raise "Error encountered when retrieving list of flavors. The message was #{ response.body }"
end

flavor = response.body[:flavors].first

puts "Using flavor '#{ flavor[:name] }' with id '#{ flavor[:id] }'"



# Get an image

puts "Retrieving images..."

response = compute.request(:list_images)

if response.status != 200
  raise "Error encountered when retrieving list of images. The message was #{ response.body }"
end

image = response.body[:images].first

puts "Using image '#{ image[:name] }' with id '#{ image[:id] }'"



# Now create the server

puts "Creating server..."

response = compute.request(:create_server) do |params|
             params.name       = "Aviator Demo #{ Time.now.iso8601 }"
             params.image_ref  = image[:id]
             params.flavor_ref = flavor[:id]
           end

puts "Server returned with a status of #{ response.status }"
pp response.body
