# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus", to: "stimulus.min.js", preload: true

# pin "bootstrap" # @5.3.3
# pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8

pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.2/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.5/lib/assets/compiled/rails-ujs.js"
pin "timestamp_formatter", to: "timestamp_formatter.js"

pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
