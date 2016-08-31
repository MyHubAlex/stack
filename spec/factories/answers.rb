FactoryGirl.define do
  factory :answer do
    content "text text"
    question 
    user 
  end

  factory :invalid_answer, class: "Answer" do 
    content ""
  end
end
