#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'aviator'
require 'pp'

session1 = Aviator::Session.new(
            config_file: Pathname.new(__FILE__).join('..', '..', 'aviator.yml').expand_path,
            environment: :demo,
            log_file:    Pathname.new(__FILE__).join('..', '..', 'aviator.log').expand_path
          )
 
session1.authenticate


print "Authenticated! Press a key to dump session info..."
gets

session_dump = session1.dump

puts session_dump

puts "\nAt this point, you can store the above session dump and reload it "\
     "at a later time. This allows your code to be efficient with Keystone tokens. "\
     "Notice how the dump contains login information. Make sure to encrypt this file "\
     "before you store it for maximum security!\n\n"\
     "Press a key to load the dump into a new session object."
gets

session2 = Aviator::Session.load(
             session_dump,
             log_file: Pathname.new(__FILE__).join('..', '..', 'aviator.log').expand_path
           )

# Validation after load is not required but is good practice.
unless session2.validate
  puts "It looks like the token associated with the session has expired!"
end

puts "Session dump loaded! Press a key to get a list of tenants you have a role in."
gets

# Without specifying an endpoint type, Aviator will look at public endpoints
# first and then admin endpoints. In the case of list_tenants, since it has
# and admin and a public 'version,' then the public version will be used below
# and that endpoint only lists the tenants where the user has a role in.
pp session2.identity_service.request(:list_tenants).body