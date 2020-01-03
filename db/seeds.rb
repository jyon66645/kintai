# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             employee_number: 0,
             uid: "a1",
             admin: true)
             
User.create!(name: "Superior User-1",
             email: "Superior1@email.com",
             password: "password",
             password_confirmation: "password",
             employee_number: 1,
             uid: "b2",
             superior: true)
             
User.create!(name: "Superior User-2",
             email: "Superior2@email.com",
             password: "password",
             password_confirmation: "password",
             employee_number: 2,
             uid: "c3",
             superior: true)

Base.create!(base_number: 1,
             base_name: "test",
             base_kind: "test",
             user_id: 1)
             

             
5.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               employee_number: n+1,
               uid: "#{n+1}")
             
end