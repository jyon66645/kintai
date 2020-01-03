class BasesController < ApplicationController
  

   before_action :admin_user, only: [:new, :index, :edit, :update, :destroy]
  
  def new
    @base = Base.new

  end
  
  def create
    @user = User.find(params[:user_id])
    @base = @user.bases.new(user_id: @user.id, base_name: base_params[:base_name], base_number: base_params[:base_number], base_kind: base_params[:base_kind])
    if @base.save
      flash[:success] = "新規作成に成功しました。"
      redirect_to user_bases_url

    else
      render :new
    end
  end
  
  def index
    @bases = Base.all
  end

  def edit
    @base = Base.find(params[:id])
  end
  
  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "更新しました！"
      redirect_to user_bases_url
    else
      render :edit
    end
  end
  
  def destroy
    @base = Base.find(params[:id])
    @base.destroy
    flash[:success] = "拠点情報を削除しました"
    redirect_to user_bases_url
  end
  
  private
  
  def base_params
    params.require(:base).permit(:base_number, :base_name, :base_kind, :user_id)
  end
  

end

