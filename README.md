= Bjond Validic App

This will serve as the Bjond integration app with the Validic API.


== Development

- Use RVM (https://rvm.io/) to deal with gemsets / ruby versions. (We've had issues with RBEnv; Use at your own risk). If you need to install rvm, use this command:

    \curl -sSL https://get.rvm.io | bash -s stable --rails

- Create an RVM gemset. This project currently uses ruby 2.2.2, so the command would be. (ruby version listed in .ruby-version and gemset name listed in .ruby-gemset) - 

    rvm ruby-2.2.2 do rvm gemset create validic-gems

- Install necessary dependencies - 

    bundle install

- Create and migrate the database using rake

    rake db:create
    rake db:migrate

- Install the client side dependencies using bower - 

    bower install

- Run the rails app -

    bin/rails server -p 3001
    
- Adding/Editing Fields -

You can add new fields in the bjond_api_initializer.rb file.  When you edit this field, you have to update your registration for the changes to show up in the BjondHealth application.  After you have saved your changes to bjond_api_initializer, restart your ruby server.  On your main localhost:3001 page, there is a listing of Bjond Registrations.  Click the "Show" link in the relevant registration.  With your localhost:8080 running, hit the "Update Registration" button.  You should see a success confirmation message.  Log out and log back in to BjondHealth, and the fields should be update.
