document.addEventListener("DOMContentLoaded", function () {
  fetch("ANALYTICS_API_PLACEHOLDER", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ page: window.location.pathname })
  });
});
