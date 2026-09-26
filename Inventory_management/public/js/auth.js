const $ = (s) => document.querySelector(s);

function showMessage(text, type="error") {
  const el = $("#message");
  el.textContent = text;
  el.className = `message show ${type}`;
}

function clearMessage() {
  $("#message").className = "message";
}

function togglePassword(id, button) {
  const input = document.getElementById(id);
  input.type = input.type === "password" ? "text" : "password";
  button.textContent = input.type === "password" ? "◉" : "○";
}

function showLogin() {
  $("#loginView").classList.remove("hidden");
  $("#signupView").classList.add("hidden");
  $("#forgotView").classList.add("hidden");
  $("#loginTab").classList.add("active");
  $("#signupTab").classList.remove("active");
  clearMessage();
}

function showSignup() {
  $("#loginView").classList.add("hidden");
  $("#signupView").classList.remove("hidden");
  $("#forgotView").classList.add("hidden");
  $("#loginTab").classList.remove("active");
  $("#signupTab").classList.add("active");
  clearMessage();
}

function showForgot() {
  $("#loginView").classList.add("hidden");
  $("#signupView").classList.add("hidden");
  $("#forgotView").classList.remove("hidden");
  clearMessage();
}

$("#loginTab").onclick = showLogin;
$("#signupTab").onclick = showSignup;
$("#forgotBtn").onclick = showForgot;
$("#backLogin").onclick = showLogin;

$("#signupForm").onsubmit = async (e) => {
  e.preventDefault();
  clearMessage();

  const full_name = $("#signupName").value.trim();
  const email = $("#signupEmail").value.trim();
  const password = $("#signupPassword").value;
  const confirm = $("#signupConfirm").value;

  if (password !== confirm) {
    showMessage("Passwords do not match.");
    return;
  }

  try {
    const response = await fetch("/api/auth/signup", {
      method: "POST",
      headers: {"Content-Type":"application/json"},
      body: JSON.stringify({full_name, email, password})
    });

    const data = await response.json();

    if (!response.ok) {
      showMessage(data.error || "Unable to create account.");
      return;
    }

    localStorage.setItem("stocksense_token", data.token);
    localStorage.setItem("stocksense_user", JSON.stringify(data.user));

    showMessage("Account created. Opening dashboard...", "success");

    setTimeout(() => {
      window.location.href = "/dashboard.html";
    }, 700);
  } catch {
    showMessage("Server connection failed.");
  }
};

$("#loginForm").onsubmit = async (e) => {
  e.preventDefault();
  clearMessage();

  try {
    const response = await fetch("/api/auth/login", {
      method: "POST",
      headers: {"Content-Type":"application/json"},
      body: JSON.stringify({
        email: $("#loginEmail").value.trim(),
        password: $("#loginPassword").value
      })
    });

    const data = await response.json();

    if (!response.ok) {
      showMessage(data.error || "Unable to login.");
      return;
    }

    localStorage.setItem("stocksense_token", data.token);
    localStorage.setItem("stocksense_user", JSON.stringify(data.user));

    showMessage("Login successful. Opening dashboard...", "success");

    setTimeout(() => {
      window.location.href = "/dashboard.html";
    }, 700);
  } catch {
    showMessage("Server connection failed.");
  }
};

$("#forgotForm").onsubmit = async (e) => {
  e.preventDefault();
  showMessage("OTP request UI is ready. Connect your email/SMS provider for actual OTP delivery.", "success");
};