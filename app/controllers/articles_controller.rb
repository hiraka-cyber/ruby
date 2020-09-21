class ArticlesController < ApplicationController
  http_basic_authenticate_with name: "dhh",password: "secret",except:[:index,:show]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @user = User.find(@article.user_id)
    @like = Like.new
    @comments = @article.comments
      @comment = @article.comments.build
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
    respond_to do |format|
      if @article.update(article_params) && @article.video.recreate_versions!
        format.html{ redirect_to @article,notice: 'Article was successfully update.'}
        format.json{ head :no_content }
      else
        format.html{ render action: 'edit'}
        format.json{ render json @article.errors,status: :unprocessable_entity}
      end
    end
  end
  private
  def article_params
    params.require(:article).permit(:title,:text,:video)
  end
end
