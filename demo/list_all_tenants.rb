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
 
keystone = session.identity_service
response = keystone.request(:list_tenants, endpoint_type: 'admin')

pp response.body
