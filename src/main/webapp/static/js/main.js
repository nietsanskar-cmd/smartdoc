// SMARTDOC Frontend JavaScript
document.addEventListener("DOMContentLoaded", function () {
    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Copy to clipboard helper
    const copyBtns = document.querySelectorAll('.btn-copy');
    copyBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
            const targetId = this.getAttribute('data-clipboard-target');
            const targetEl = document.querySelector(targetId);
            if (targetEl) {
                navigator.clipboard.writeText(targetEl.value || targetEl.innerText).then(function () {
                    const originalText = btn.innerHTML;
                    btn.innerHTML = '<i class="bi bi-check2"></i> Copied!';
                    setTimeout(function () {
                        btn.innerHTML = originalText;
                    }, 2000);
                });
            }
        });
    });
});
