# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    subject "MyText"
    body "MyText"
    read_at "2012-09-25 09:51:02"
    archived_at "2012-09-25 09:51:02"
  end
end