window.addEventListener("load", function () {
    fetch("API_PLACEHOLDER/analytics", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ page: window.location.pathname })
    });
  });
  