class PostsController < ApplicationController
  before_action :set_tabs, only: :index
  before_action :set_sort_methods, only: :index
  before_action :set_tab, only: :index
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :check_post_owner, only: %i[ edit update destroy ]

  # GET /posts or /posts.json
  def index
    case @tab
    when :my_posts
      @posts = Post.where(user: current_user).order(selected_sort_method)
    when :liked_posts
      @posts = current_user.likes.where(likable_type: 'Post').map(&:likable)
    else
      @tab = :all_posts unless @tab
      @posts = Post.where(public: true).order(selected_sort_method)
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(**post_params, user_id: current_user.id)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_tabs
      @tabs = {
        all_posts: 'All posts',
        my_posts: 'My posts',
        liked_posts: 'Liked posts'
      }
    end

    def set_tab
      @tab = params[:tab].to_sym if params[:tab]
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:image, :description, :public)
    end

    def check_post_owner
      unless @post.user.eql? current_user
        redirect_to root_path, alert: "You don't have permission to do that."
      end
    end

    def set_sort_methods
      @sort_methods = {
        'Newest first' => { created_at: :desc },
        'Oldest first' => { created_at: :asc },
        'Most recently updated' => { updated_at: :desc },
        'Least recently updated' => { updated_at: :asc },
        'Most liked' => { likes_count: :desc },
        'Least liked' => { likes_count: :asc }
      }
    end

    def selected_sort_method
      @sort_methods[params[:sort_by] || 'Newest first'] || @sort_methods['Newest first']
    end

end
