class PhonesController < ApplicationController
  before_action :set_parser, only: [:brands, :models]
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

  private

  def all_importers
    [:GsmArena]
  end

  def set_parser
    #FIXIT
    return 'errr' unless params[:importer] || all_importers.include?(params[:importer])
    @parser = "::Parsers::#{params[:importer]}".constantize.new
  end
end
