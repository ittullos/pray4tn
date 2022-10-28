    FROM lambci/lambda:build-ruby2.7
    RUN yum -y install mysql-devel
    RUN gem update bundler
    RUN bundle config --local deployment 'false'
    RUN bundle install
    RUN bundle config --local deployment 'true'
    RUN bundle install
    # CMD "/bin/bash"