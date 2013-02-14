# encoding: utf-8

module Monkey

  class App

    helpers Sinatra::RedirectWithFlash

    helpers do
      # This gives us the currently logged in user. We keep track of that by just
      # setting a session variable with their is. If it doesn't exist, we want to
      # return nil.
      def current_person
        unless @cp and @request.session[:person_id]
          @cp = Person.get(@request.session[:person_id])
        end
        @cp
      end

      # Checks if this is a logged in person
      def has_auth?
        !current_person.nil?
      end

      # Returns the current domain name
      def domain
        domain = request.host
        domain << ":#{request.port}" unless [80, 443].include?(request.port)
        domain
      end
    end
  end
end
