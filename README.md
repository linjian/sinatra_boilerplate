A sinatra boilerplate, API only framework.

## Initialize

```
bundle install
cp config/database.yml.example config/database.yml
cp config/settings.yml.example config/settings.yml
```

## Start server

```
thin -R config.ru -p 4567 start
thin -R config.ru -p 4567 -e production start
```

## Console

```
./console
RACK_ENV=production ./console
```
