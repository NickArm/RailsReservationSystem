document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".delete-button").forEach((button) => {
        button.addEventListener("click", (event) => {
            const bookingId = button.dataset.bookingId;

            // Display custom confirmation dialog
            const confirmation = confirm(
                `Are you sure you want to delete booking #${bookingId}? This action cannot be undone.`
            );

            // Prevent form submission if user cancels
            if (!confirmation) {
                event.preventDefault();
            }
        });
    });

    const flashMessages = document.querySelectorAll(".alert");
    flashMessages.forEach((message) => {
        setTimeout(() => {
            message.classList.add("fade-out");
            setTimeout(() => message.remove(), 500);
        }, 3000);
    });
});
