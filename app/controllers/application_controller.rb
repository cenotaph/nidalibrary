class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :load_menus
  
  def load_menus
    @statuses = Status.all
    @sections = Section.all.order(:name)
  end
  
end
