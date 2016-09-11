FactoryGirl.define do
  factory :question do
    title "MyString have to min 15 character"
    body "MyText"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
