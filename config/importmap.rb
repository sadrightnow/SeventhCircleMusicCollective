# Pin npm packages by running ./bin/importmap


# config/importmap.rb

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/dist/stimulus.min.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "slim-select"
