// Import Rails UJS so `method: :delete` works
import Rails from "@rails/ujs"
Rails.start()

// Import controllers if using Stimulus
import "controllers"

// Initialize SlimSelect
import SlimSelect from "slim-select"

document.addEventListener("DOMContentLoaded", () => {
  const selectElement = document.querySelector('#selectElement')
  if (selectElement) {
    const select = new SlimSelect({
      select: selectElement
      // Optional: keep order of selected values
      // settings: { keepOrder: true }
    })

    // Example: log selected values whenever needed
    console.log(select.getSelected()) // Returns an array of selected values
  }
})
