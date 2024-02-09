require 'test_helper'

class CourseControllerTest < ActionDispatch::IntegrationTest
  test 'should create a new course with tutors' do
    assert_difference('Course.count') do
      post courses_url, params: {
        course: { name: 'Math', tutors_attributes: [{ name: 'John Doe', email: 'john@example.com' }] }
      }, as: :json
    end

    assert_response :created
  end

  test 'should return unprocessable entity for invalid course data' do
    post courses_url, params: { course: { name: '' } }, as: :json
    assert_response :unprocessable_entity
  end

  test 'should return a list of courses with tutors' do
    course = courses(:history)
    Tutor.create(name: 'Jane Doe', email: 'jane@example.com', course: course)

    get courses_url, as: :json
    assert_response :ok

    response_body = JSON.parse(response.body)
    assert_includes response_body, 'id'
    assert_includes response_body, 'name'
    assert_includes response_body, 'tutors'
  end
end
