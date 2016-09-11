FactoryGirl.define do
  factory :answer do
    content "text text"
    question 
    user 
    best false
  end

  factory :answer_best, class: Answer do
    content "bla bla"
    question 
    user 
    best true
  end

  factory :invalid_answer, class: "Answer" do 
    content ""
  end
end
