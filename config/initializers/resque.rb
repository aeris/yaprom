#redis_config = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
#Resque.redis = Redis.new host: redis_config[:host], port: redis_config[:port], namespace: redis_config[:namespace]
#Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
