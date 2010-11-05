class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.all
    respond_to do |format|
      format.html # index.html.erb
      # format.xml do
      #   result=Array.new
      #   @articles.each do |article|
      #     hash = Hash.new
      #     hash[:title] = article.title
      #     hash[:subtitle] = article.subtitle
      #     hash[:body] = article.body
      #     hash[:date] = article.date
      #     hash[:thumbnails] = Array.new
      #     hash[:gallery_photos] = Array.new
      #     article.gallery_items.each do |gallery_item|
      #       hash[:thumbnails].push gallery_item.image.url(:iphone_thumb)
      #       hash[:gallery_photos].push gallery_item.image.url(:iphone_gallery)
      #     end
      #     result.push hash
      #   end
      #   render :xml => result
      # end
    end
  end

  def redirect_to_download
    if request.user_agent.include? "iPhone"
      redirect_to_iphone
      return
    end

    if request.user_agent.include? "BlackBerry"
      redirect_to "http://dlus.mevo.mobi/livingetc_live/LivingEtc.jad"
      return
    end

    render :text => "Sorry, your mobile phone is currently not supported. Please check back soon. Thank you."
  end

  def redirect_to_iphone
    redirect_to "http://livingetc.mobi/iphone/"
  end


  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml do
        # @galleries
        result= Array.new
        @article.gallery_items.each do |item|
          hash = Hash.new
          hash[:image_url] = item.image.url(:bb)
          hash[:thumbnail_url] = item.image.url(:iphone_thumb)
          if item.description != ""
            hash[:caption] = item.description 
          end
          result.push hash
        end
        render :xml => result
      end
      
      # IPHONE VIEW # ONLY IMAGES, NO CONTENT
      format.json do
        # @galleries
        result= Array.new
        @article.gallery_items.each do |item|
          hash = Hash.new
          hash[:src] = item.image.url(:iphone_gallery)
          if item.description != ""
            hash[:caption] = item.description 
          end
          result.push hash
        end
        render :json => result.to_json
      end
    end
  end

  def article_ajax
    @article = Article.find(params[:id])
    
    respond_to do |format|
      format.html {render :template => "articles/show_ajax", :layout => false}
    end
  end


  def article_bb
    @article = Article.find(params[:id])
    
    respond_to do |format|
      format.html {render :template => "articles/show_bb", :layout => false}
    end
  end
  
  
  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
end
