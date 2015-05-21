# Fwitter Project!

This iteration of the Fwitter project focuses on adding sessions and authorization to persist a logged-in user throughout the application. Most of the work is done in the application controller and the views.

+ `application_controller.rb`:
  * In order for an application to keep track of one user's usage (and know which user!), the application needs to keep track of a session. We set this up in the configure block in the controller by adding:
  ```ruby
  enable :sessions
  set :session_secret, 'fwitter'
  ```
  * Every session has a unique id number that is made up of a random sequence of letters and numbers. This sequence is generated through the session_secret. The secret can be anything; in this case its "fwitter".
  * Now that our app is set up to handle sessions, we need to create login functionality. That means we need a form dedicated to login. 
  * Our sign-in form POSTs to a route `/sign-in`. This controller action uses the `find_by` method to check to see if the user's email address and name exist in the database. If it does, it adds a key-value pair to the session hash. Every user has a unique id so we use store that in the session hash to keep track of the user throughout their experience in the app. Now they're logged in!
  * We also need user's to be able to log out. Signing out is processed by a GET request to `/sign-out`. This controller action sets the `user_id` in the session hash to `nil`.
  * Helpers: We need to set up some helper methods in our controller that become useful to track things like is the user signed in or not? We will use the helper methods in the view
    * We set up helper methods through a block:
    ```ruby
    helpers do
    end
    ```
    * `signed_in?` This method returns the user_id in the session hash. This method helps us check if the user is signed in.
    * 
