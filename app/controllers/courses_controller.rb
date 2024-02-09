class CoursesController < ApplicationController
  before_action :set_course, only: [:show]

  def create
    @course = Course.new(course_params)
    if @course.save
      render json: @course, status: :created
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  def index
    @courses = Course.includes(:tutors)
    render json: @courses, include: 'tutors', status: :ok
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, tutors_attributes: [:id, :name, :email])
  end
end
