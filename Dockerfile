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

RUN curl https://gist.github.com/Andyvanee/3728e498455219cdada2/raw/7592eeccc96fb50161bbdd270dfdabe06fc66d54/Gemfile > /var/www/Gemfile

RUN curl https://gist.github.com/Andyvanee/b95b463126cdb9d5630c/raw/13988ed1f517cdf96b4b6e7ed45e3351567747c1/nginx.conf > /etc/nginx/sites-available/default

RUN cd /var/www && bundle install

# CMD service php5-fpm start && nginx -g "daemon off;"
