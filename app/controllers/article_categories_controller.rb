class ArticleCategoriesController < ApplicationController
  # GET /article_categories
  # GET /article_categories.xml
  def index
    @article_categories = ArticleCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @article_categories }
    end
  end

  # GET /article_categories/1
  # GET /article_categories/1.xml
  def show
    @article_category = ArticleCategory.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml do
        result=Array.new
        @article_category.articles.each do |article|
          hash = Hash.new
          hash[:title] = article.title
          hash[:subtitle] = article.subtitle
          hash[:url] = "/article_bb/#{article.id}"
          hash[:gallery_url] = "/articles/#{article.id}.xml"
          hash[:date] = article.date
          if article.gallery_items != []
            hash[:thumbnail] = article.gallery_items[0].image.url(:iphone_thumb).gsub(/\?.*$/, "").gsub(" ", "%20")
          end
          # hash[:thumbnails] = Array.new
          # hash[:gallery_photos] = Array.new
          # article.gallery_items.each do |gallery_item|
          #   hash[:thumbnails].push gallery_item.image.url(:iphone_thumb).gsub(/\?.*$/, "").gsub(" ", "%20")
          #   hash[:gallery_photos].push gallery_item.image.url(:iphone_gallery).gsub(/\?.*$/, "").gsub(" ", "%20")
          # end
          result.push hash
        end
        render :xml => result
      end
      
      # format.json do
      #   result_hash= Array.new
      #   articles = @article_category.articles
      #   0.upto(@article_category.articles.size()-1) do |article_id|
      #     article = articles[article_id]
      #     hash = Hash.new
      #     hash[:title] = article.title
      #     hash[:category] = article.article_category.name.upcase
      #     hash[:date] = article.date
      #     hash[:id] = article.id
      #     result_hash.push hash
      #   end
      #   render :json => result_hash.to_json
      # end
    end
  end


  def article_category_ajax
    @article_category = ArticleCategory.find(params[:id])
    
    respond_to do |format|
      format.html {render :template => "article_categories/show_ajax", :layout => false}
    end
  end
  
  
  # GET /article_categories/new
  # GET /article_categories/new.xml
  def new
    @article_category = ArticleCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article_category }
    end
  end

  # GET /article_categories/1/edit
  def edit
    @article_category = ArticleCategory.find(params[:id])
  end

  # POST /article_categories
  # POST /article_categories.xml
  def create
    @article_category = ArticleCategory.new(params[:article_category])

    respond_to do |format|
      if @article_category.save
        format.html { redirect_to(@article_category, :notice => 'Article category was successfully created.') }
        format.xml  { render :xml => @article_category, :status => :created, :location => @article_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /article_categories/1
  # PUT /article_categories/1.xml
  def update
    @article_category = ArticleCategory.find(params[:id])

    respond_to do |format|
      if @article_category.update_attributes(params[:article_category])
        format.html { redirect_to(@article_category, :notice => 'Article category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /article_categories/1
  # DELETE /article_categories/1.xml
  def destroy
    @article_category = ArticleCategory.find(params[:id])
    @article_category.destroy

    respond_to do |format|
      format.html { redirect_to(article_categories_url) }
      format.xml  { head :ok }
    end
  end
end
