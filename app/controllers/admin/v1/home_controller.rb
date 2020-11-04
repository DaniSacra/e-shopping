module Admin::V1
  class HomeController < ApiController
    def index
      render json: {message: 'Passou no HomeController'}
    end
    
  end
end