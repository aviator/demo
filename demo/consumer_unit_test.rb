#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'aviator'

#
# Sample Aviator consumer object
#
class AviatorConsumer

  def do_one_thing(username, password, tenant_id)
    openstack = authenticate
    response = openstack.request(:identity,
                                 :create_user,
                                 :params => {
                                   :name      => username,
                                   :password  => password,
                                   :tenant_id => tenant_id })
    response[:body][:user][:id]
  end

  def do_another_thing(username, password)
    openstack = authenticate :params => { :username => username, :password => password }
    openstack.authenticated?
  end


  private

  def authenticate(opts={})
    openstack = Aviator::Session.new(
                  config_file: 'path/to/aviator.yml',
                  environment: :production,
                  log_file:    'path/to/aviator.log'
                )
    openstack.authenticate(opts)
    openstack
  end

end


#
# Sample unit test of consumer object
#
gem 'mocha'
require 'minitest/unit'
require 'minitest/autorun'
require 'mocha/mini_test'


describe AviatorConsumer do

  it "must do one thing" do
    #
    # Prepare mock session
    #
    mock_session = mock('Aviator::Session')
    Aviator::Session.expects(:new).returns(mock_session)

    mock_session.expects(:authenticate)

    new_user    = 'anotheruser'
    new_user_id = 'asdflkj123'
    new_pswd    = 'anotherpswd'
    tenant_id   = 'atenantid'

    mock_session
      .expects(:request)
      .with(:identity, :create_user,
            :params => {
              :name      => new_user,
              :password  => new_pswd,
              :tenant_id => tenant_id })
      .returns(Hashish.new({
                :status => 200,
                :headers => {
                  :stuff => :here},
                :body => {
                  :user => {
                    :name     => new_user,
                    :id       => new_user_id,
                    :tenantId => tenant_id,
                    :enabled  => true,
                    :email    => "dump@foo.com"
                  }
                }
              }))

    #
    # Exercise consumer code
    #
    consumer = AviatorConsumer.new
    user_id = consumer.do_one_thing(new_user, new_pswd, tenant_id)

    #
    # Validate results
    #
    user_id.must_equal new_user_id
  end


  it "must do another thing" do
    #
    # Prepare mock session
    #
    mock_session = mock('Aviator::Session')
    Aviator::Session.expects(:new).returns(mock_session)

    username = 'someuser'
    password = 'password'

    mock_session
      .expects(:authenticate)
      .with({:params => {
               :username => username,
               :password => password}})

    mock_session
      .expects(:authenticated?)
      .returns(true)

    #
    # Exercise consumer code
    #
    consumer = AviatorConsumer.new
    result = consumer.do_another_thing(username, password)

    #
    # Validate results
    #
    result.must_equal true
  end

end
