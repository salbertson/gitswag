require 'redis'
redis_url = ENV['REDISCLOUD_URL']
if redis_url
  uri = URI.parse(redis_url)
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  $redis = Redis.new
end
