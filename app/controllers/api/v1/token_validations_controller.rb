# frozen_string_literal: true

module Api::V1
  class TokenValidationsController < DeviseTokenAuth::TokenValidationsController

    def validate_token
      # Rails.logger.error 'THIS IS HAPPENING FIRST'
      # @resource will have been set by set_user_by_token concern
      if @resource
        yield @resource if block_given?
        render_validate_token_success
      else
        render_validate_token_error
      end
    end


    protected

    def render_validate_token_success
      # Rails.logger.error 'THIS IS HAPPENING'
      render json: { data: { id: @resource.id.to_s,  roles: 'admin', name: @resource.name, email: @resource.email }, status: 200 }
    end

  end
end

