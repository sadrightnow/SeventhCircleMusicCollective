import SlimSelect from 'slim-select';
import 'slim-select/dist/slimselect.css';

document.addEventListener("DOMContentLoaded", function() {
  // Initialize Slim Select on the band select element
  new SlimSelect({
    select: '#band_select', // The ID of your select element
    closeOnSelect: false // Optional: allows multiple selections
  });

  new SlimSelect({
    select: '#genre_select',
    closeOnSelect: false // Optional: allows multiple selections
  });
});

document.addEventListener('turbolinks:load', () => {
  new SlimSelect({
    select: '#genre_select',  // Make sure this matches the ID in your view
        closeOnSelect: false // Optional: allows multiple selections
  });
});



const application = Application.start()
const context = require.context("./controllers", true, /\.js$/) // Keep this as is
application.load(definitionsFromContext(context))
