class PhonesController < ApplicationController
  before_action :set_parser, only: [:brands, :models, :detail]
  def index
    #TODO: it can load all parsers, but currently it enough
    @importers = all_importers
  end

  def brands
    @brands = @parser.brands
    render json: @brands
  end

  def models
    @models = @parser.models(params[:brand])
    render json: @models
  end

  def detail
    @phone = @parser.phone_detail(params[:model])
    respond_to do |format|
      format.html { render 'detail', layout: false }
      format.json { render json: @phone }
    end
  end

  private

  def all_importers
    [:GsmArena]
  end

  def set_parser
    @parser = "::Parsers::#{params[:importer]}".constantize.new
  end
end
