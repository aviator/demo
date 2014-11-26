#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'aviator'

class AviatorConsumer

  def do_one_thing
    session = authenticate

    keystone = session.identity_service
    response = keystone.request(:list_tenants)
    response.body
  end

  def do_another_thing
    session = authenticate

    response = session.compute_service.request(:create_server)
    response.status
  end

  private

  def authenticate
    openstack = Aviator::Session.new(
                  config_file: 'path/to/aviator.yml',
                  environment: :production,
                  log_file:    'path/to/aviator.log'
                )
    openstack.authenticate
    openstack
  end

end


gem 'mocha'
require 'minitest/unit'
require 'minitest/autorun'
require 'mocha/mini_test'


describe AviatorConsumer do

  # Shared objects

  def consumer
    @consumer ||= AviatorConsumer.new
  end

  def mock_session
    @mock ||= mock('Aviator::Session')
  end

  # Common expectation for session auth

  def expects_authentication
      options = {
        config_file: 'path/to/aviator.yml',
        environment: :production,
        log_file:    'path/to/aviator.log'
      }
      Aviator::Session.expects(:new).with(options).returns(mock_session)
      mock_session.expects(:authenticate)
  end

  # Expectations

  it "must do one thing" do
    mock_keystone = mock('Aviator::Service')
    mock_response = mock('Aviator::Response')
    mock_body = { id: 'something' }

    expects_authentication
    mock_session.expects(:identity_service).returns(mock_keystone)
    mock_keystone.expects(:request).with(:list_tenants).returns(mock_response)
    mock_response.expects(:body).returns(mock_body)

    consumer.do_one_thing.must_equal mock_body
  end

  it "must do another thing" do
    mock_nova = mock('Aviator::Service')
    mock_response = mock('Aviator::Response')
    mock_status = 200

    expects_authentication
    mock_session.expects(:compute_service).returns(mock_nova)
    mock_nova.expects(:request).with(:create_server).returns(mock_response)
    mock_response.expects(:status).returns(mock_status)

    consumer.do_another_thing.must_equal mock_status
  end

end
