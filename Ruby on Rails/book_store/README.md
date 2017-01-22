# book_store

This project uses:
- [Ruby on Rails 4](http://rubyonrails.org/)
- [Docker](https://www.docker.com/)

# init (new project)
```bash
docker-compose build
docker-compose run --rm --no-deps web /sbin/setuser app /bin/bash -c 'rails new /home/app/book_store -f -B -d=postgresql && mv /home/app/book_store/{*,.*} /home/app/webapp/ 2> /dev/null && rmdir /home/app/book_store'
vim config/database.yml # dockerize database.yml
docker-compose run --rm web /sbin/setuser app /bin/bash -c 'bundle && bundle exec rake db:create'
docker-compose up
```

# after git clone
```bash
docker-compose run --rm web /sbin/setuser app /bin/bash -c 'bundle && bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed'
docker-compose up
# localhost:3000
```

# login data
| Email               | Password |
|---------------------|----------|
| admin@bookstore.pl  | qwerty12 |
| worker@bookstore.pl | qwerty12 |
| user1@bookstore.pl  | qwerty12 |
