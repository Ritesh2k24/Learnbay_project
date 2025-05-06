window.addEventListener("load", function () {
    fetch("https://<your-api>.execute-api.us-east-1.amazonaws.com/analytics", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ page: window.location.pathname })
    });
  });
  