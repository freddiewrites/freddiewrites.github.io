// Newsletter signup on the home page.
//
// Shows our own error messages in place of the browser's tooltips. Without
// this script, the browser's built-in checks still stop empty or invalid
// fields. The form opens Buttondown in a new tab, so this page stays put.
(function () {
  var form = document.querySelector(".newsletter-form");
  if (!form) return;

  var button = form.querySelector(".newsletter-button");
  var status = form.querySelector(".newsletter-status");
  var buttonLabel = button.textContent;
  var fields = Array.prototype.slice.call(form.querySelectorAll("input[required]"));

  // We show the messages ourselves, so turn off the browser's tooltips
  form.noValidate = true;

  function messageFor(input) {
    if (input.validity.valueMissing) {
      return input.type === "email"
        ? "Please enter your email address."
        : "Please enter your first name.";
    }
    if (input.validity.typeMismatch) {
      return "That email address doesn’t look right.";
    }
    return "";
  }

  function check(input) {
    var error = document.getElementById(input.getAttribute("aria-describedby"));
    var message = messageFor(input);

    error.textContent = message;
    error.hidden = !message;
    if (message) {
      input.setAttribute("aria-invalid", "true");
    } else {
      input.removeAttribute("aria-invalid");
    }
    return !message;
  }

  // Pressing the button moves focus off a field. If that field's error
  // appeared then, it could push the button out from under the pointer and
  // swallow the click, so leave it to the submit check instead
  var pressingButton = false;
  button.addEventListener("pointerdown", function () {
    pressingButton = true;
  });
  window.addEventListener("pointerup", function () {
    pressingButton = false;
  });

  fields.forEach(function (input) {
    // Only check once someone has left the field, not while they type
    input.addEventListener("blur", function () {
      if (pressingButton) {
        pressingButton = false;
        return;
      }
      if (input.value.trim() !== "" || input.hasAttribute("aria-invalid")) check(input);
    });
    // Once a field shows an error, clear it as soon as it's fixed
    input.addEventListener("input", function () {
      if (input.hasAttribute("aria-invalid")) check(input);
    });
  });

  form.addEventListener("submit", function (event) {
    status.textContent = "";
    fields.forEach(function (input) {
      input.value = input.value.trim();
    });

    var invalid = fields.filter(function (input) {
      return !check(input);
    });
    if (invalid.length) {
      event.preventDefault();
      invalid[0].focus();
      return;
    }

    // The form opens in a new tab. Show progress briefly, then reset here
    button.disabled = true;
    button.textContent = "Subscribing…";
    setTimeout(function () {
      form.reset();
      button.disabled = false;
      button.textContent = buttonLabel;
      status.textContent = "Almost there. Finish up in the new tab, then check your inbox to confirm.";
    }, 1500);
  });
})();
