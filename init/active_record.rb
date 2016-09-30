db_file = File.join(settings.root, 'config/database.yml')
ActiveRecord::Base.establish_connection YAML::load(IO.read(db_file))[ENV["RACK_ENV"]]
ActiveRecord::Base.default_timezone = :local
