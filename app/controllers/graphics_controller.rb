class GraphicsController < ApplicationController
  before_action :set_graphic, only: [:show, :update, :destroy]

  # GET /graphics
  def index
    @graphics = Graphic.all

    render json: @graphics
  end

  # GET /graphics/1
  def show
    render json: @graphic
  end

  # POST /graphics
  def create
    @graphic = Graphic.new(graphic_params)

    if @graphic.save
      render json: @graphic, status: :created, location: @graphic
    else
      render json: @graphic.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /graphics/1
  def update
    if @graphic.update(graphic_params)
      render json: @graphic
    else
      render json: @graphic.errors, status: :unprocessable_entity
    end
  end

  # DELETE /graphics/1
  def destroy
    @graphic.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_graphic
      @graphic = Graphic.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def graphic_params
      params.fetch(:graphic, {})
    end
end
