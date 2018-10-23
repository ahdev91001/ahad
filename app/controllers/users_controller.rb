class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      flash[:success] = "Your account has been created! Welcome to AHAD you wonderful person you!"
      flash.keep # not even sure why this is needed, but it was
      # second answer at: https://stackoverflow.com/questions/7510418/
      #                     rails-redirect-to-with-error-but-flasherror-empty
      redirect_to user_url(@user) 
    else
      render 'new'
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
