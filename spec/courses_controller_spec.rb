# spec/controllers/courses_controller_spec.rb

require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe 'POST #create' do
    it 'creates a new course with tutors' do
      post :create, params: {
        course: {
          name: 'Math',
          tutors_attributes: [
            { name: 'John Doe', email: 'john@example.com' },
            { name: 'Jane Doe', email: 'jane@example.com' }
          ]
        }
      }, format: :json

      expect(response).to have_http_status(:created)
      expect(Course.count).to eq(1)
      expect(Tutor.count).to eq(2)
    end
    it 'returns unprocessable entity for invalid course data' do
      post :create, params: { course: { name: '' } }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(Course.count).to eq(0)
    end
  end

  describe 'GET #index' do
    it 'returns a list of courses with tutors' do
      course = Course.create(name: 'History')
      tutor = Tutor.create(name: 'Jane Doe', email: 'jane@example.com', course: course)

      get :index, format: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).count).to eq(1)
      expect(JSON.parse(response.body)[0]['name']).to eq('History')
      expect(JSON.parse(response.body)[0]['tutors'].count).to eq(1)
    end
  end
end
