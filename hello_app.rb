#
require 'sinatra'
require 'json'
require 'redis'


configure do
  begin
    credentials = {'credentials'=>{'port'=>'6379', 'hostname'=>'localhost', 'password'=>''}}

      if ENV['VCAP_SERVICES']
        services = JSON.parse(ENV['VCAP_SERVICES'])
        redis_service = services['rediscloud-n/a']
        redis_service = services['redis-2.6'] unless redis_service
        credentials = redis_service.first['credentials'] if redis_service
      end
      $redis = Redis.new(host: credentials['hostname'], port: credentials['port'], password: credentials['password'])
    rescue Exception => e
      $stderr.puts 'Error in config'
      $stderr.puts "Error: #{e.message}"
  end
end

get '/' do
   data = []
   t1 = Time.now
   $redis.set('foo', 'bar')
   t2 = Time.now
   $redis.get('foo')
   t3 = Time.now
   data << 'write'
   data << t2-t1
   data << 'read'
   data << t3-t2
  'Hello world! ' + data.to_s
end
