class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy, :retrieve, :subscribe]


  # GET /feeds
  def index
    @feeds = Feed.all
  end

  # GET /feeds/1
  def show
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit
  end

  # GET /feeds/1/retrieve
  def retrieve
    body, ok, reques = SuperfeedrEngine::Engine.retrieve_by_topic_url(@feed.url, {:format => 'json'})
    json = JSON.parse(body)
    json['items'].each do |i|
      @feed.entries.create(:title => i["title"], :link => i["permalinkUrl"], :description => i["content"])
    end
    flash[:info] = "Retrieved and saved entries"
    redirect_to @feed
  end


  # POST /feeds/1/subscribe
  def subscribe
    SuperfeedrEngine::Engine.subscribe(@feed)
    redirect_to @feed, notice: 'Subscribed!'
  end

  # POST /feeds
  def create
    @feed = Feed.new(feed_params)

    if @feed.save
      redirect_to @feed, notice: 'Feed was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /feeds/1
  def update
    if @feed.update(feed_params)
      redirect_to @feed, notice: 'Feed was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /feeds/1
  def destroy
    @feed.destroy
    redirect_to feeds_url, notice: 'Feed was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def feed_params
      params.require(:feed).permit(:title, :url)
    end
end
