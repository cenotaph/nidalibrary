# frozen_string_literal: true

module Api::V1
  # This is the parent API controller which the individual APIs inherit things from
  class ApiController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken

    def respond_with_errors(exception)
      if exception.respond_to?('errors')
        # Rails.logger.error exception.errors.inspect
        message = exception.errors.full_messages.join('; ')
      elsif exception.message
        # Rails.logger.error exception.message
        message = exception.message
      else
        message = 'Unknown error!'
      end

      render json: { errors: [{ title: message, status: 422 }] }, status: :unprocessable_entity
    end
  end
end
