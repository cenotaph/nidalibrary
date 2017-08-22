class SectionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  
  
  def edit
    @section = Section.friendly.find(params[:id])
  end
  
  def index
    @sections = Section.all
  end
  
  def new
    @section = Section.new
  end
  
  def create
    @section = Section.new(section_params)

    respond_to do |format|
      if @section.save
        format.html { redirect_to sections_url, notice: 'Section was successfully created.' }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def shelfread
    @section = Section.friendly.find(params[:id])
    @books = @section.books.order(:catno)
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    @section = Section.friendly.find(params[:id])
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to sections_url, notice: 'Section was successfully updated.' }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section = Section.friendly.find(params[:id])
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_url, notice: 'Section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end  
  
  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:name, :colour)
    end
    
      
  
end