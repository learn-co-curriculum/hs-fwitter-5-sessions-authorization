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
  * Our app also handles GET requests for the `/sign-in` route also, so a user can go directly to the sign in page. This controller action sets an instance variable `@signin_page` which is used later in the view to determine whether or not to display the sign-in form (a user already signed in doesn't need to see that page)
  * We also need user's to be able to log out. Signing out is processed by a GET request to `/sign-out`. This controller action sets the `user_id` in the session hash to `nil`.
  * Helpers: We need to set up some helper methods in our controller that become useful to track things like is the user signed in or not? We use the helper methods in the view
    * We set up helper methods through a block:
    ```ruby
    helpers do
    end
    ```
    * `signed_in?`: This method returns the user_id in the session hash. This method helps us check if the user is signed in.
    * `current_user`: This method finds a user based on the id in the session hash and returns that user object.s
    * `error`: This method returns an error.
+ `layout.erb`:
  * The layout needs to get updated to display specific information depending on if a user is signed-in or not.
  * Here, we use the helper method `signed_in?` to check if we have signed in user or not. If they are signed in, then we display a link to sign-out. If they're not signed in, then we display the sign-in link.

+ `signin.erb`:
  * This file users displays both the sign-in form and the sign-out form.
  * The sign-out form is taken from `users.erb` day04 Fwitter.
  * The sign-in form sends a POST request to `/sign-in` in the controller. The user's email and name gets sent via the params hash to the controller.

+ `tweet.erb`:
  * We only want a user to be able to tweet if they are logged in
  * The create tweet form needs to get wrapped in an if statement that checks to see if the user is logged in.
  * We do that by checking `<%= if session[:user_id] %> exists. If it does, then the form is displayed.


<a href='https://learn.co/lessons/hs-fwitter-5-sessions-authorization' data-visibility='hidden'>View this lesson on Learn.co</a>
