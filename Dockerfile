FROM octohost/ruby-2.0.0p247

MAINTAINER Andy VanEe <andy@nonfiction.ca>

ENV PATH /usr/local/rvm/gems/ruby-2.0.0-p247/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get -y install python-software-properties
RUN add-apt-repository -y ppa:nginx/stable
RUN add-apt-repository -y ppa:ondrej/php5-oldstable
RUN apt-get update
RUN apt-get -y install nginx php5-cli php5-fpm php5-mysql php-apc php5-imagick php5-imap php5-mcrypt php5-memcache

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN sed -i 's|127.0.0.1:9000|/var/run/php5-fpm.sock|g' /etc/php5/fpm/pool.d/www.conf

# run a bundle install before ADD in order to cache
RUN mkdir /var/www

RUN curl https://raw.github.com/octohost/php5-nginx-ruby/master/Gemfile > /var/www/Gemfile

RUN curl https://raw.github.com/octohost/php5-nginx-ruby/master/nginx.conf > /etc/nginx/sites-available/default

RUN cd /var/www && bundle install

# CMD service php5-fpm start && nginx -g "daemon off;"
