
class PostsController < ApplicationController
  before_action :set_post, except: [:index, :new, :archive]
  before_action :authenticate_user!, except: [:index, :show]


  def index
    if current_user.admin?
      if params[:type] == "user"
        if params[:most]
          posts_id = React.group(:post_id).order("count_all DESC").count
          @res = posts_id.keys.uniq.map do |id|
            Post.find(id).user
          end
          @res = @res.uniq
        else
          @pagy, @res = pagy_countless(User.all, items:10)
        end
      else
        if params[:status].present? && Post.statuses.keys.include?(params[:status])
          @pagy, @res = pagy_countless(Post.send(params[:status]), items:10)
        else
          @pagy, @res = pagy_countless(Post.all, items:10)
        end
      end
    else
      @pagy, @posts = pagy_countless(current_user.posts, items:10)
    end
  end

  def new
    @post = Post.create(status: :draft, user_id: current_user.id)
    redirect_to edit_post_path(@post)
  end

  def edit
    render layout: "without_create_post" 
  end


  def destroy
    if @post.destroy
      redirect_to user_path(current_user)
    end
  end


  def update
    case params[:status]
    when "pending"
      @post.status = :pending
      @post.assign_attributes(post_params)
    when "published"
      @post.status = params[:status]
    when "declined"
      @post.status = params[:status]
    else
      @post.status = :draft
      @post.assign_attributes(post_params)
    end
    if @post.save
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  


  def show
  end

  private
  def post_params
    params.require(:post).permit(:title, :content)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
