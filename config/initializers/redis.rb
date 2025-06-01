if ENV['DOCKERIZED'] == 'true'
  Redis.new(url: 'redis://redis:6379/0')
else
  Redis.new(url: 'redis://localhost:6380/0')
end
