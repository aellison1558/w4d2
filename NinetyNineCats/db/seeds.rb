10.times do
  age = Faker::Date.birthday(min_age = 0, max_age = 65)
  color = ['turquoise', 'magenta', 'cyan'].sample
  name = Faker::Name.title + " " + Faker::Name.last_name
  sex = ['f', 'm'].sample
  description = "sample description"
  Cat.create(birth_date: age, color: color, name: name, sex: sex, description: description)
end

25.times do
  cats = Cat.all
  cat_id = cats.sample.id
  start_date = Faker::Date.backward(days = 30)
  end_date = Faker::Date.forward(days = 30)
  CatRentalRequest.create(cat_id: cat_id, start_date: start_date,
          end_date: end_date, status: "PENDING")
end
