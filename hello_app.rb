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
   data = []
   t1 = Time.now
   $redis.set("foo", "bar")
   t2 = Time.now
   $redis.get('foo')
   t3 = Time.now
   data << 'write'
   data << t2-t1
   data << 'read'
   data << t3-t2
  'Hello world! ' + data.to_s
end
