# encoding: utf-8

module Monkey

  class App

    helpers Sinatra::RedirectWithFlash

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html

      # This gives us the currently logged in user. We keep track of that by just
      # setting a session variable with their is. If it doesn't exist, we want to
      # return nil.
      def current_person
        unless @cp and @request.session[:user_id]
          @cp = User.get(@request.session[:user_id])
        end
        @cp
      end

      # Checks if this is a logged in person
      def has_auth?
        !current_person.nil?
      end

      # Check if current person is logged in and is admin
      def has_admin?
        has_auth? && current_person.is_admin
      end

      # Returns the current domain name
      def domain
        domain = request.host
        domain << ":#{request.port}" unless [80, 443].include?(request.port)
        domain
      end

      # checks for authorized user and redirects to the login page if user
      # is not authorized.
      def authorize!
        redirect to("/login?to=#{request.path}", true, false) unless has_auth?
      end

    end
  end
end
