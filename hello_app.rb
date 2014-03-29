#
require 'sinatra'
require 'json'
require 'redis'


configure do

    credentials = {"credentials"=>{"port"=>"6379", "hostname"=>"localhost", "password"=>""}}

    if ENV['VCAP_SERVICES']
      rediscloud_service = JSON.parse(ENV['VCAP_SERVICES'])["rediscloud-n/a"]
      credentials = rediscloud_service.first["credentials"]
    end

    puts credentials.to_s
    $redis = Redis.new(:host => credentials["hostname"], :port => credentials["port"], :password => credentials["password"])
end

get '/' do
   $redis.set("foo", "bar")
  'Hello world! ' + $redis.get('foo')
end
