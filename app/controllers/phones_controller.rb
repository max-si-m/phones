class PhonesController < ApplicationController
  before_action :set_parser, except: [:index]

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

  def search
    respond_with_text('Query not found') and return unless params[:q].present?

    queries = params[:q].split
    brands = @parser.brands
    brand = brands.select { |b| include_text?(queries, b) }.try(:first)
    respond_with_text('Brand not found') and return unless brand.present?

    models = @parser.models(brand)
    model = models.select { |b| include_text?(queries, b) }.try(:first)
    respond_with_text('Model not found') and return unless model.present?

    @phone = @parser.phone_detail(model)
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

  def include_text?(array, text)
    array.any? { |e| e[/#{text}$/ix].present? }
  end

  def respond_with_text(text)
    respond_to { |f| f.json { render json: { error: text } } }
  end
end
