docker build -t registry.heroku.com/dot-net-angular-image/web .
docker push registry.heroku.com/dot-net-angular-image/web  
heroku container:release web --app dot-net-angular-image