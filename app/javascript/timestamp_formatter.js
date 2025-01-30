document.addEventListener("DOMContentLoaded", function () {
  const formatTimestamps = () => {
    document.querySelectorAll(".timestamp").forEach((element) => {
      const utcTimestamp = element.getAttribute("data-utc");
      if (utcTimestamp) {
        const localDate = new Date(utcTimestamp);
        const formattedDate = localDate.toLocaleString("en-GB", {
          month: "short",
          day: "2-digit",
          year: "numeric"
          // hour: "2-digit",
          // minute: "2-digit",
          // hour12: true,
        });
        element.textContent = formattedDate;
      }
    });
  };

  const formatFullTimestamps = () => {
    document.querySelectorAll(".full-timestamp").forEach((element) => {
      const utcTimestamp = element.getAttribute("data-utc");
      if (utcTimestamp) {
        const localDate = new Date(utcTimestamp);
        const formattedDate = localDate.toLocaleString("en-GB", {
          month: "short",
          day: "2-digit",
          year: "numeric",
          hour: "2-digit",
          minute: "2-digit",
          hour12: true,
        });
        element.textContent = formattedDate;
      }
    });
  };


  // Format timestamps on initial page load
  formatTimestamps();
  formatFullTimestamps();

  // Re-run the function if Turbo (or other frameworks) replaces content
  document.addEventListener('turbo:load', formatTimestamps);
  document.addEventListener('turbo:load', formatFullTimestamps);
});
