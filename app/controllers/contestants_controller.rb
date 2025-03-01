class ContestantsController < ApplicationController
  before_action :set_contest, only: %i[index new edit show update create]
  before_action :set_contestant, only: %i[edit show update destroy]
  before_action :authenticate_user!, only: %i[new edit update destroy]
  before_action :authorize_admin, only: %i[edit update destroy]

  def index
    @contestants = @contest.contestants.includes(:user).all
  end

  def show
    @comments = @contestant.comments
  end

  def edit
  end

  def new
    @contestant = @contest.contestants.build
  end

  def create
    @contestant = @contest.contestants.build(contestant_params.merge(user: current_user))

    if @contestant.save
      respond_to do |format|
        format.html { redirect_to contest_contestant_path(@contest, @contestant), notice: "Welcome to the #{@contest.name} contest! Your submission has been submitted for review" }
        format.json { render json: @contestant, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to new_contest_contestant_path(@contest), alert: @contestant.errors.full_messages.to_sentence }
        format.json { render json: @contestant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    modified_params = if params[:approved].present?
                        contestant_params.merge(approved_by: current_user, approved_at: Time.current)
                      end

    if @contestant.update!(modified_params || contestant_params)
      redirect_to request.referer, notice: "Contestant was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contestant.discard
    redirect_to contestants_path, notice: "Contestant was successfully removed."
  end

  private

  def set_contest
    @contest = Contest.find(params[:contest_id])
  end

  def set_contestant
    @contestant = Contestant.friendly.find(params[:slug])
  end

  def contestant_params
    params.require(:contestant).permit(:stage_name, :description, :contest_id, :approved, :approved_by_id, :approved_at, :image)
  end

  def authorize_admin
    redirect_to root_path, alert: "Access Denied" unless current_user.admin?
  end
end
