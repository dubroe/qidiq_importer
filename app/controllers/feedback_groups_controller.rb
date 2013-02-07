class FeedbackGroupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :call_api_import]
  load_and_authorize_resource except: [:index, :call_api_import]
  
  def index
    @feedback_groups = current_user.try(:feedback_groups)
  end

  def show
    @import_post_url = call_api_import_feedback_group_url(@feedback_group)
  end

  def new
  end

  def edit
  end

  def create
    if @feedback_group.save
      redirect_to @feedback_group, notice: 'Feedback group was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @feedback_group.update_attributes(params[:feedback_group])
      redirect_to @feedback_group, notice: 'Feedback group was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @feedback_group.destroy
    redirect_to feedback_groups_url
  end
  
  def call_api_import
    feedback_group = FeedbackGroup.find(params[:id])
    if /^[a-zA-Z0-9_\.\+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+$/.match(params[:email])
      result_string = feedback_group.import_user params[:email]
      result_json = JSON.parse(result_string).symbolize_keys
      result_code = result_json[:error_code]
    else
      result_code = '7'
    end
    if params[:redirect_url]
      first_char = params[:redirect_url].index('?').nil? ? '?' : '&'
      redirect_to "#{params[:redirect_url]}#{first_char}result_code=#{result_code}&email=#{params[:email]}"
    elsif result_code.zero?
      render text: "#{params[:email]} successfully added to the #{feedback_group.url} qidiq feedback group."
    else
      render text: "Failed to add #{params[:email]} to the #{feedback_group.url} qidiq feedback group."
    end
  end
end
