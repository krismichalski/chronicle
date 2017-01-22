FROM phusion/passenger-ruby22:0.9.18
MAINTAINER contact@nooulaif.com

# Set correct environment variables
ENV HOME=/root \
    BUNDLE_GEMFILE=/home/app/webapp/Gemfile \
    BUNDLE_RETRY=3 \
    BUNDLE_PATH=/home/app/bundle \
    BUNDLE_DISABLE_SHARED_GEMS=1

# Create dir for app
# Set correct permissions
RUN /sbin/setuser app mkdir -p /home/app/webapp/ \
    && /sbin/setuser app mkdir -p /home/app/bundle/ \
    && groupmod -g 1000 app \
    && usermod -u 1000 -g 1000 app \
    && chown -R app:app /home/app

# Install libraries (remember about specyfing version! (<package name>=<version>)
# check with: apt-cache showpkg <package name>)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      libpq-dev=9.3.11-0ubuntu0.14.04 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install rails
RUN gem install rails -v 4.2.6

##### CHANGE DIRECTORY FOR RUN TO APP DIR #####
WORKDIR /home/app/webapp
