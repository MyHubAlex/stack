FactoryGirl.define do
  factory :comment_for_question, class: Comment do
    commentable_id  1
    commentable_type "Question"
    body "MyText"
    user
  end

end