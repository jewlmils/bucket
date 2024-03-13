class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
    private
  
    def record_not_found(exception)
      model_name = exception.model.constantize.model_name
      flash[:alert] = "Oops, #{model_name} not found"
      redirect_to root_path
    end
  end