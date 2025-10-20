// app/javascript/controllers/slim_controller.js
import SlimSelect from 'slim-select';

document.addEventListener('DOMContentLoaded', function() {
  // Initialize Slim Select for genres
  new SlimSelect({
    select: '#genre_select' // Target the genre select field
  });

  // Optionally, you can initialize Slim Select for other selects, like band select
  new SlimSelect({
    select: '#band_select' // Target the band select field
  });
});
