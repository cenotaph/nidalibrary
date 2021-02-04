# frozen_string_literal: true

module Api::V1
  # device types controller. admins only?
  class HousekeepingController < ApiController
    respond_to :json
    before_action :authenticate_user!, only: [:clean_commas]

    def check_callnos
      @books = Book.preload(:status :fasts).where("call_number is not null").order(:call_number)
      render json: BookSerializer.new(@books).serializable_hash.to_json, status: :ok
    end

    def clean_commas
      @book = Book.find(params[:id])
      @book.author = Book.clean_partnerships(@book.author)
      if @book.save
        render json: BookSerializer.new(@book).serializable_hash.to_json, status: :ok
      else
        render status: 422, json: @book.errors.inspect.to_json
      end
    end

    def old_order
      @books = Book.preload(:fasts).where("ddc is not null").order(:section_id, :catno)
      render json: BookSerializer.new(@books).serializable_hash.to_json, status: :ok
    end
    
    def problem_authors
      @books = Book.preload(:fasts).where(author_is_institution: false).where(Book.arel_table[:author].does_not_match('%,%'))
      render json: BookSerializer.new(@books).serializable_hash.to_json, status: :ok
    end

    def probably_healthy_authors
      @books = Book.preload(:fasts).where(author_is_institution: false).where("author LIKE '%,%'")
      render json: BookSerializer.new(@books).serializable_hash.to_json, status: :ok
    end
    
    def dewey_sweep
      codes = Book.where("ddc is not null").group_by(&:ddc).sort.map{|g| [ g.first, g.last.size] }
      codes.each do |code|
        places = code.first.to_s.split('.').last.size
        (-2..places).each do |pr|
          codes.push([code.first.truncate(pr), 0]) unless codes.map(&:first).include?(code.first.truncate(pr))
        end
      end
          

      # deweys = Dewey.where(ddc: codes)
      deweys = Dewey.where(code: codes.map(&:first) )
      d = []
      codes.sort_by(&:first).each do |ddc|        
        name = deweys.find_by(code: ddc.first)
        d.push({code: ddc.first, name: name.nil? ? nil : name.name, book_count:  ddc.last })
      end
      render json: d.to_json, status: 200
    end
    
    
    def mapcallnos
      @precision = params[:precision] ||= -2
      offset = [1000, 100, 10, 1, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001]
      @precision = 7 if @precision.to_i > 7
      clause = "ddc is not null"
      if params[:range] && @precision.to_i > -2
        clause += ' and ddc >= ' + params[:range].to_f.truncate(@precision.to_i - 1).to_s + ' and ddc < ' + (params[:range].to_f + offset[@precision.to_i + 2].to_f).to_s
      end
      data = Book.where(clause).group_by{|x| x.ddc.truncate(@precision.to_i).to_s}.sort.map{|g| [ g.first, g.last.size] }
      render json: [data, data.map{|x| "#{x.first.gsub(/\.0$/,'')}: #{Dewey.find_by(code: x.first).name.gsub(/\s\-\sGeneralities$/,'') rescue 'Code unknown'}" }, @precision].to_json, status: :ok

    end
    
    def unclassified
      @books = Book.where(ddc: nil).order(:section_id, :catno, updated_at: :desc)
      render json: BookSerializer.new(@books).serializable_hash.to_json, status: :ok
    end
  end
end