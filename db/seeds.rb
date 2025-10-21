# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

begin
  user = User.find_or_create_by(email: 'froelichperry1@gmail.com') do |u|
    u.password = 'default_password'
    u.password_confirmation = 'default_password'
  end

  if user.persisted?
    if user.update(admin: true)
      puts "User #{user.email} is now an admin."
    else
      puts "Failed to update admin status: #{user.errors.full_messages.join(', ')}"
    end
  else
    puts "Failed to create user: #{user.errors.full_messages.join(', ')}"
  end
rescue => e
  puts "An error occurred: #{e.message}"
end

# Seed genres
puts "Seeding genres..."
file_path_genres = Rails.root.join('config', 'genres.json')
genres_data = JSON.parse(File.read(file_path_genres))['genres']

genres_data.each do |genre_name|
  Genre.find_or_create_by(name: genre_name)
end
puts "Genres seeding complete!"

# Seed events
puts "Seeding events..."
file_path_events = Rails.root.join('db', 'events.json')
events_data = JSON.parse(File.read(file_path_events))

events_data.each_with_index do |event_data, index|
  begin
    # Parse the date from MM/DD/YYYY format
    event_date = Date.strptime(event_data['event_date'], '%m/%d/%Y')

    # Create a new Post record
    Post.create!(
      event_name: event_data['event_name'],
      event_date: event_date
    )

    # Log progress every 100 events
    puts "Created event #{index + 1}" if (index + 1) % 100 == 0
  rescue StandardError => e
    puts "Error creating event #{index + 1}: #{e.message}"
  end
end
puts "Events seeding complete!"

