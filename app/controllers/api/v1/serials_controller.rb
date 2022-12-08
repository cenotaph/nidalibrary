# frozen_string_literal: true

module Api::V1
  # device types controller. admins only?
  class SerialsController < ApiController
    before_action :authenticate_user! , except: %i[show index]
    # skip_load_and_authorize_resource only: %i[create destroy index]
    respond_to :json
    
    def create
      @serial = Serial.new(serial_params)
      if @serial.save
        render json: SerialSerializer.new(@serial).serializable_hash.to_json, status: :created
      else
        respond_with_errors(@serial) 
      end
    end

    def destroy
      @serial = Serial.find(params[:id])
      if @serial.destroy
        head :no_content
      else
        respond_with_errors(@serial) 
      end
      
    end
    
    def index
      params[:page] ||= 1
      if params[:collection_id]
        @collection = Collection.friendly.find(params[:collection_id])
        @serials = @collection.serials.order(:title).page(params[:page]).per(50)
      elsif params[:section_id]
        @section = Section.friendly.find(params[:section_id])
        @serials = @section.serials.order(:title).page(params[:page]).per(50)
      elsif params[:fast_id]
        @section = Fast.find(params[:fast_id])
        @serials = @section.serials.page(params[:page]).per(50)
      elsif params[:status_id]
        @status = Status.friendly.find(params[:status_id])
        @serials = @status.serials.order(:title).page(params[:page]).per(50)
      elsif params[:format] == 'csv'
        require 'csv'
        @serials = Serial.all.order("id desc, updated_at, title")
        respond_to do |format|
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"serial-list\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end
      else

        @serials = Serial.order("id desc, updated_at, title").page(params[:page]).per(50)
      end
      options = {}
      options[:meta] = { total: @serials.total_pages }
      options[:links] = {
        self: params[:section_id] ? v1_section_serials_path(@section.slug) : v1_serials_path(),
        next: params[:page].to_i < @serials.total_pages ? (params[:section_id] ? v1_section_serials_path(@section.slug, page: params[:page].to_i  + 1) : v1_serials_path(page: params[:page].to_i  + 1)) : nil, 
        prev: params[:page].to_i  == 1 ? nil : (params[:section_id] ? v1_section_serials_path(@section.slug, page: params[:page].to_i  - 1) : v1_serials_path(page:  params[:page].to_i  - 1))
      }
      render json: SerialSerializer.new(@serials, options).serializable_hash.to_json, status: 200
    end

    def search_oclc
      if params[:search] =~ /^978/ 
        # search by isbn
        @serial = Serial.search_isbn(params[:search])
        if @serial
          @serial.isbn13 = params[:search].gsub(/\D/, '')
          Rails.logger.error @serial.inspect
          render json: SerialSerializer.new(@serial).serializable_hash.to_json, status: 200
        else
          render json: {}, status: 404
        end
      end

    end
    

    def show
      @serial = Serial.find(params[:id])
      render json: SerialSerializer.new(@serial).serializable_hash.to_json, status: 200
    end

    def update
      @serial = Serial.find(params[:id])
      if @serial.update(serial_params)
        render json: SerialSerializer.new(@serial).serializable_hash.to_json, status: 200
      else
        respond_with_errors(@serial)
      end
    end

    private

    def serial_params
      params.require(:serial).permit(:issn, :title, :subtitle, :volume, :number, :year, :month, :publisher, :status_id, :comment, :copies, :language, :provenance, :image)
    end
  end
end