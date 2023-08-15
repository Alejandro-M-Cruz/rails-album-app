# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.find_by! email: 'alejandroxdlx@gmail.com'

10.times do |i|
  post = Post.new(
    description: "Post #{i}",
    public: true,
    user_id: user.id
  )
  image_path = Rails.root.join('app/assets/images/favicon.png')
  post.image.attach(io: File.open(image_path), filename: 'favicon.png')
  post.save!
end
