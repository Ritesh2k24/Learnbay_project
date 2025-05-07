document.getElementById("contact-form").addEventListener("submit", async function (e) {
    e.preventDefault();
  
    const name = document.getElementById("name").value;
    const email = document.getElementById("email").value;
    const message = document.getElementById("message").value;
  
    const response = await fetch("API_PLACEHOLDER/submit", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name, email, message })
    });
  
    const result = await response.json();
    alert(result.message);
  });
  