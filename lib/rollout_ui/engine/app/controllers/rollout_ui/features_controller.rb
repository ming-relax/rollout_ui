require 'rest_client'

module RolloutUi
  class FeaturesController < RolloutUi::ApplicationController
    before_filter :wrapper, :only => [:index]

    def index
      @features = @wrapper.features.map{ |feature| RolloutUi::Feature.new(feature) }
    end

    def update
      @feature = RolloutUi::Feature.new(params[:id])

      @feature.percentage = params["percentage"] if params["percentage"]
      @feature.groups     = params["groups"]     if params["groups"]
      @feature.user_ids   = params["users"]      if params["users"]

      report_to_hubot(params[:id], params["percentage"]) if params["percentage"]

      redirect_to features_path
    end

  private

    def wrapper
      @wrapper = RolloutUi::Wrapper.new
    end

    def report_to_hubot(feature, percentage)
      hubot_endpoint = "http://strikingly-hubot.herokuapp.com/hubot/rollout"
      RestClient.post(
        hubot_endpoint, 
        { 'feature' => feature, 'percentage' => percentage }.to_json, 
        :content_type => :json, 
        :accept => :json
      )
    end

  end
end
