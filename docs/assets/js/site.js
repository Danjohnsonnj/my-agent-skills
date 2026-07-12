(function () {
  "use strict";

  var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* Install clipboard — copy exact pre text */
  var copyBtn = document.querySelector("[data-copy-install]");
  var snippet = document.getElementById("install-snippet");

  if (copyBtn && snippet) {
    copyBtn.addEventListener("click", function () {
      var text = snippet.textContent || "";
      function done() {
        copyBtn.setAttribute("data-copied", "true");
        copyBtn.textContent = "Copied";
        window.setTimeout(function () {
          copyBtn.removeAttribute("data-copied");
          copyBtn.textContent = "Copy";
        }, 1600);
      }

      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(done).catch(function () {
          fallbackCopy(text, done);
        });
      } else {
        fallbackCopy(text, done);
      }
    });
  }

  function fallbackCopy(text, done) {
    var ta = document.createElement("textarea");
    ta.value = text;
    ta.setAttribute("readonly", "");
    ta.style.position = "absolute";
    ta.style.left = "-9999px";
    document.body.appendChild(ta);
    ta.select();
    try {
      document.execCommand("copy");
      done();
    } finally {
      document.body.removeChild(ta);
    }
  }

  /* Lifecycle rail — draw once on first in-view */
  var rail = document.querySelector("[data-rail]");
  if (rail) {
    if (reduceMotion) {
      rail.classList.add("is-inview");
    } else if ("IntersectionObserver" in window) {
      var io = new IntersectionObserver(
        function (entries) {
          entries.forEach(function (entry) {
            if (entry.isIntersecting) {
              rail.classList.add("is-inview");
              io.disconnect();
            }
          });
        },
        { threshold: 0.35 }
      );
      io.observe(rail);
    } else {
      rail.classList.add("is-inview");
    }
  }
})();
