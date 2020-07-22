class Regular::BaseController < ApplicationController
  before_action :require_regular

  def require_regular
    puts "Running require_regular"
    render file: "/public/404" unless current_regular?
  end
end
