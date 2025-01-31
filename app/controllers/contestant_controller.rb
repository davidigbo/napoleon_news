class ContestantsController < ApplicationController
    before_action :set_contestant, only: %i[show edit update destroy]
    before_action :authenticate_user!, only: %i[edit update destroy]
    before_action :authorize_admin, only: %i[edit update destroy]

    def index
        @contestants = Contestant.includes(:user).all
    end

    def show
        @contestant = Contestant.find(params[:id])
    end

    def edit
    end

    def update
        if @contestant.update(contestant_params)
            redirect_to @contestant, notice: "Contestant was successfully updated."
        else
            render :edit
        end
    end

    def destroy
        @contestant.discard
        redirect_to contestants_path, notice: "Contestant was successfully removed."
    end

    private

    def set_contestant
        @contestant = Contestant.find(params[:id])
    end

    def contestant_params
        params.require(:contestant).permit(:description, :image, :approved, :approved_by_id, :approved_at)
    end

    def authorize_admin
        redirect_to root_path, alert: "Access Denied" unless current_user.admin?
    end
end
