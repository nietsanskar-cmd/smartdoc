<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Reset Password &bull; NIET Student Document Management System</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="<c:url value='/static/img/niet-logo.png'/>">

    <!-- Google Fonts: Plus Jakarta Sans & Inter -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800;900&display=swap" rel="stylesheet"/>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>

    <!-- Tailwind CSS v3 -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = {
          theme: {
            extend: {
              fontFamily: {
                sans: ["'Inter'", "sans-serif"],
                display: ["'Plus Jakarta Sans'", "sans-serif"]
              },
              colors: {
                niet: {
                  50: "#FFF1F2",
                  100: "#FFE4E6",
                  200: "#FECDD3",
                  300: "#FDA4AF",
                  400: "#FB7185",
                  500: "#F43F5E",
                  600: "#E11D48",
                  700: "#D71920",
                  800: "#A50F16",
                  900: "#881337"
                }
              }
            }
          }
        };
    </script>

    <style>
        body {
          font-family: 'Inter', sans-serif;
          background: radial-gradient(circle at 15% 20%, rgba(215, 25, 32, 0.04) 0%, #FAFAFC 45%, #F0F4F8 100%);
          overflow-x: hidden;
        }

        .font-display {
          font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .glass-card {
          background: rgba(255, 255, 255, 0.94);
          backdrop-filter: blur(20px);
          -webkit-backdrop-filter: blur(20px);
          border: 1px solid rgba(255, 255, 255, 0.9);
          box-shadow: 0 20px 45px -10px rgba(0, 0, 0, 0.06), 0 8px 20px -4px rgba(215, 25, 32, 0.03);
        }

        .btn-niet {
          background: linear-gradient(135deg, #D71920 0%, #A50F16 100%);
          color: white;
          box-shadow: 0 4px 14px rgba(215, 25, 32, 0.28);
          transition: all 0.25s ease;
        }

        .btn-niet:hover {
          background: linear-gradient(135deg, #E3262E 0%, #B81119 100%);
          box-shadow: 0 6px 20px rgba(215, 25, 32, 0.38);
          transform: translateY(-1px);
        }

        .btn-niet:disabled {
          opacity: 0.6;
          cursor: not-allowed;
          transform: none;
          box-shadow: none;
        }

        .otp-input {
          width: 48px;
          height: 56px;
          font-size: 24px;
          font-weight: 800;
          text-align: center;
          border-radius: 12px;
          border: 2px solid #E2E8F0;
          background: #F8FAFC;
          color: #111827;
          transition: all 0.2s ease;
        }

        .otp-input:focus {
          border-color: #D71920;
          background: #FFFFFF;
          outline: none;
          box-shadow: 0 0 0 3px rgba(215, 25, 32, 0.15);
        }

        .step-pill.active {
          background-color: #D71920;
          color: white;
        }

        .step-pill.completed {
          background-color: #10B981;
          color: white;
        }
    </style>
</head>
<body class="min-h-screen text-slate-800 antialiased flex flex-col justify-between relative selection:bg-niet-500 selection:text-white">

    <!-- Header Navigation -->
    <header class="relative z-10 w-full px-6 py-4 flex items-center justify-between max-w-7xl mx-auto">
        <a href="<c:url value='/'/>" class="flex items-center gap-3.5 group">
            <img src="<c:url value='/static/img/niet-logo.png'/>" alt="NIET Logo" class="h-10 sm:h-12 w-auto object-contain transition-transform duration-300 group-hover:scale-105"/>
            <div class="flex flex-col">
                <span class="font-display font-black text-slate-900 text-lg sm:text-xl tracking-tight leading-tight">
                    NIET <span class="text-niet-700">SDMS</span>
                </span>
                <span class="text-[10px] sm:text-[11px] font-semibold tracking-wider text-slate-500 uppercase">
                    Autonomous Institute &bull; Greater Noida
                </span>
            </div>
        </a>

        <div class="flex items-center gap-3">
            <a href="<c:url value='/login'/>" class="text-xs font-bold text-slate-600 hover:text-niet-700 transition-colors">
                <i class="bi bi-box-arrow-in-right me-1"></i> Back to Login
            </a>
        </div>
    </header>

    <!-- Main Wizard Container -->
    <main class="relative z-10 flex-1 flex items-center justify-center px-4 py-8 max-w-7xl mx-auto w-full">
        <div class="w-full max-w-xl mx-auto">
            
            <!-- Stepper Progress Header -->
            <div class="mb-6 text-center">
                <h1 class="font-display font-extrabold text-2xl sm:text-3xl text-slate-950 tracking-tight">Reset Account Password</h1>
                <p class="text-xs sm:text-sm text-slate-500 mt-1">Verify your official @niet.co.in email to restore access</p>
                
                <!-- Step Indicator Pills -->
                <div class="flex items-center justify-center gap-2 sm:gap-4 mt-5">
                    <div class="flex items-center gap-2">
                        <div id="step-pill-1" class="step-pill active w-7 h-7 rounded-full flex items-center justify-center font-bold text-xs transition-colors duration-300">1</div>
                        <span class="text-xs font-semibold text-slate-600 hidden sm:inline">Identify</span>
                    </div>
                    <div class="w-8 h-0.5 bg-slate-200"></div>
                    <div class="flex items-center gap-2">
                        <div id="step-pill-2" class="step-pill w-7 h-7 rounded-full bg-slate-200 text-slate-600 flex items-center justify-center font-bold text-xs transition-colors duration-300">2</div>
                        <span class="text-xs font-semibold text-slate-400 hidden sm:inline">OTP</span>
                    </div>
                    <div class="w-8 h-0.5 bg-slate-200"></div>
                    <div class="flex items-center gap-2">
                        <div id="step-pill-3" class="step-pill w-7 h-7 rounded-full bg-slate-200 text-slate-600 flex items-center justify-center font-bold text-xs transition-colors duration-300">3</div>
                        <span class="text-xs font-semibold text-slate-400 hidden sm:inline">New Password</span>
                    </div>
                </div>
            </div>

            <!-- Card Body -->
            <div class="glass-card rounded-2xl p-6 sm:p-8 relative overflow-hidden">
                
                <!-- Global Alert Box -->
                <div id="alert-box" class="hidden mb-6 rounded-xl p-3.5 text-xs font-medium border flex items-start gap-2.5 transition-all">
                    <i id="alert-icon" class="bi text-base shrink-0 mt-0.5"></i>
                    <div id="alert-msg" class="flex-1"></div>
                </div>

                <!-- ================= STEP 1: EMAIL IDENTIFICATION ================= -->
                <div id="step-1-container">
                    <div class="mb-5">
                        <h2 class="font-display font-bold text-lg text-slate-900">Enter Your Official NIET Email</h2>
                        <p class="text-xs text-slate-500 mt-0.5">We will send a 6-digit verification code to your college email inbox.</p>
                    </div>

                    <form id="step-1-form" onsubmit="handleSendOtp(event)" class="space-y-4">
                        <div>
                            <label for="emailInput" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Official NIET Email ID</label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 text-slate-400">
                                    <i class="bi bi-envelope"></i>
                                </span>
                                <input type="email" id="emailInput" required placeholder="user@niet.co.in"
                                       class="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 placeholder-slate-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-transparent transition-all"/>
                            </div>
                            <p class="text-[11px] text-slate-500 mt-1.5 flex items-center gap-1">
                                <i class="bi bi-shield-check text-niet-600"></i>
                                Strictly accepts emails ending with <strong class="text-slate-700">@niet.co.in</strong>
                            </p>
                        </div>

                        <button type="submit" id="send-otp-btn" class="w-full btn-niet font-semibold py-3 px-4 rounded-xl text-sm flex items-center justify-center gap-2 mt-6">
                            <span>Send Verification OTP</span>
                            <i class="bi bi-arrow-right"></i>
                        </button>
                    </form>
                </div>

                <!-- ================= STEP 2: OTP VERIFICATION ================= -->
                <div id="step-2-container" class="hidden">
                    <div class="mb-5 text-center">
                        <div class="w-12 h-12 rounded-full bg-niet-50 text-niet-700 flex items-center justify-center mx-auto mb-2 text-xl">
                            <i class="bi bi-shield-lock"></i>
                        </div>
                        <h2 class="font-display font-bold text-lg text-slate-900">Check Your NIET Inbox</h2>
                        <p class="text-xs text-slate-500 mt-1">
                            We sent a 6-digit OTP code to <br/>
                            <strong id="display-target-email" class="text-slate-800 font-bold"></strong>
                            <button type="button" onclick="goToStep(1)" class="ml-1 text-niet-700 hover:underline text-[11px] font-semibold">(Change)</button>
                        </p>
                    </div>

                    <form id="step-2-form" onsubmit="handleVerifyOtp(event)" class="space-y-6">
                        <!-- 6-Box OTP Inputs -->
                        <div class="flex items-center justify-center gap-2 sm:gap-3 my-4">
                            <input type="text" maxlength="1" class="otp-input" id="otp-1" inputmode="numeric" autocomplete="one-time-code"/>
                            <input type="text" maxlength="1" class="otp-input" id="otp-2" inputmode="numeric"/>
                            <input type="text" maxlength="1" class="otp-input" id="otp-3" inputmode="numeric"/>
                            <input type="text" maxlength="1" class="otp-input" id="otp-4" inputmode="numeric"/>
                            <input type="text" maxlength="1" class="otp-input" id="otp-5" inputmode="numeric"/>
                            <input type="text" maxlength="1" class="otp-input" id="otp-6" inputmode="numeric"/>
                        </div>

                        <div class="flex items-center justify-between text-xs text-slate-500 px-1">
                            <span>Code expires in <strong id="expiry-timer" class="text-slate-700">05:00</strong></span>
                            <button type="button" id="resend-btn" disabled onclick="handleResendOtp()" class="text-slate-400 font-semibold cursor-not-allowed transition-colors">
                                Resend in <span id="cooldown-timer">45s</span>
                            </button>
                        </div>

                        <button type="submit" id="verify-otp-btn" class="w-full btn-niet font-semibold py-3 px-4 rounded-xl text-sm flex items-center justify-center gap-2">
                            <span>Verify Code</span>
                            <i class="bi bi-check2-circle text-lg"></i>
                        </button>
                    </form>
                </div>

                <!-- ================= STEP 3: NEW PASSWORD ================= -->
                <div id="step-3-container" class="hidden">
                    <div class="mb-5">
                        <h2 class="font-display font-bold text-lg text-slate-900">Set New Password</h2>
                        <p class="text-xs text-slate-500 mt-0.5">Choose a secure password for your NIET account.</p>
                    </div>

                    <form id="step-3-form" onsubmit="handleResetPassword(event)" class="space-y-4">
                        <!-- New Password -->
                        <div>
                            <label for="newPasswordInput" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">New Password</label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 text-slate-400">
                                    <i class="bi bi-key"></i>
                                </span>
                                <input type="password" id="newPasswordInput" required oninput="evaluatePasswordStrength(this.value)"
                                       placeholder="Enter at least 8 characters"
                                       class="w-full pl-10 pr-10 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 placeholder-slate-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-transparent transition-all"/>
                                <button type="button" onclick="togglePasswordVisibility('newPasswordInput', this)" class="absolute inset-y-0 right-0 flex items-center pr-3.5 text-slate-400 hover:text-slate-600">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>

                            <!-- Live Password Strength Meter -->
                            <div class="mt-2 space-y-1.5">
                                <div class="flex items-center justify-between text-[11px] font-semibold">
                                    <span class="text-slate-500">Strength:</span>
                                    <span id="strength-label" class="text-slate-400">Empty</span>
                                </div>
                                <div class="w-full h-1.5 bg-slate-100 rounded-full overflow-hidden">
                                    <div id="strength-bar" class="h-full w-0 bg-slate-300 transition-all duration-300 rounded-full"></div>
                                </div>
                            </div>

                            <!-- Password Requirement Checklist -->
                            <div class="mt-2.5 grid grid-cols-2 gap-1.5 text-[11px] text-slate-500 bg-slate-50 p-2.5 rounded-lg border border-slate-100">
                                <div id="req-len" class="flex items-center gap-1.5"><i class="bi bi-circle text-slate-300"></i> &ge; 8 Characters</div>
                                <div id="req-upper" class="flex items-center gap-1.5"><i class="bi bi-circle text-slate-300"></i> Uppercase (A-Z)</div>
                                <div id="req-lower" class="flex items-center gap-1.5"><i class="bi bi-circle text-slate-300"></i> Lowercase (a-z)</div>
                                <div id="req-digit" class="flex items-center gap-1.5"><i class="bi bi-circle text-slate-300"></i> Number (0-9)</div>
                            </div>
                        </div>

                        <!-- Confirm Password -->
                        <div>
                            <label for="confirmPasswordInput" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Confirm New Password</label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 text-slate-400">
                                    <i class="bi bi-lock-check"></i>
                                </span>
                                <input type="password" id="confirmPasswordInput" required
                                       placeholder="Re-type your new password"
                                       class="w-full pl-10 pr-10 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 placeholder-slate-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-transparent transition-all"/>
                                <button type="button" onclick="togglePasswordVisibility('confirmPasswordInput', this)" class="absolute inset-y-0 right-0 flex items-center pr-3.5 text-slate-400 hover:text-slate-600">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>

                        <button type="submit" id="reset-pwd-btn" class="w-full btn-niet font-semibold py-3 px-4 rounded-xl text-sm flex items-center justify-center gap-2 mt-6">
                            <span>Update Password</span>
                            <i class="bi bi-shield-check"></i>
                        </button>
                    </form>
                </div>

                <!-- ================= STEP 4: SUCCESS STATE ================= -->
                <div id="step-4-container" class="hidden text-center py-4">
                    <div class="w-16 h-16 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center mx-auto mb-4 text-3xl shadow-sm border border-emerald-100">
                        <i class="bi bi-check-lg"></i>
                    </div>
                    <h2 class="font-display font-extrabold text-xl text-slate-900">Password Updated!</h2>
                    <p class="text-xs sm:text-sm text-slate-500 mt-1 max-w-sm mx-auto">
                        Your NIET account password has been successfully reset. You can now log in with your updated credentials.
                    </p>

                    <div class="mt-6">
                        <a href="<c:url value='/login?resetSuccess=true'/>" class="w-full btn-niet font-semibold py-3 px-4 rounded-xl text-sm inline-flex items-center justify-center gap-2">
                            <span>Proceed to Login</span>
                            <i class="bi bi-box-arrow-in-right"></i>
                        </a>
                    </div>
                </div>

            </div>

            <!-- Footer Notes -->
            <div class="mt-6 text-center text-xs text-slate-400">
                Need assistance? Contact <a href="mailto:support@niet.co.in" class="text-niet-700 hover:underline">support@niet.co.in</a> &bull; SDMS Security Portal
            </div>

        </div>
    </main>

    <!-- Page Footer -->
    <footer class="relative z-10 w-full py-4 text-center text-slate-400 text-xs border-t border-slate-200/60 bg-white/40 backdrop-blur-sm">
        &copy; 2026 Noida Institute of Engineering and Technology. All rights reserved.
    </footer>

    <!-- Client-Side Controller Logic -->
    <script>
        const contextPath = '<c:url value="/"/>'.replace(/\/$/, '');
        let currentStep = 1;
        let verifiedEmail = '';
        let cooldownInterval = null;
        let expiryInterval = null;

        // Display alerts
        function showAlert(msg, type = 'error') {
            const alertBox = document.getElementById('alert-box');
            const alertIcon = document.getElementById('alert-icon');
            const alertMsg = document.getElementById('alert-msg');
            
            alertBox.className = "mb-6 rounded-xl p-3.5 text-xs font-medium border flex items-start gap-2.5 transition-all";
            if (type === 'error') {
                alertBox.classList.add('bg-rose-50', 'text-rose-700', 'border-rose-200');
                alertIcon.className = 'bi bi-exclamation-triangle-fill text-base shrink-0 mt-0.5 text-rose-600';
            } else if (type === 'success') {
                alertBox.classList.add('bg-emerald-50', 'text-emerald-700', 'border-emerald-200');
                alertIcon.className = 'bi bi-check-circle-fill text-base shrink-0 mt-0.5 text-emerald-600';
            } else if (type === 'info') {
                alertBox.classList.add('bg-blue-50', 'text-blue-700', 'border-blue-200');
                alertIcon.className = 'bi bi-info-circle-fill text-base shrink-0 mt-0.5 text-blue-600';
            }
            alertMsg.innerHTML = msg;
            alertBox.classList.remove('hidden');
        }

        function hideAlert() {
            document.getElementById('alert-box').classList.add('hidden');
        }

        // Stepper Navigation
        function goToStep(step) {
            hideAlert();
            currentStep = step;

            document.getElementById('step-1-container').classList.toggle('hidden', step !== 1);
            document.getElementById('step-2-container').classList.toggle('hidden', step !== 2);
            document.getElementById('step-3-container').classList.toggle('hidden', step !== 3);
            document.getElementById('step-4-container').classList.toggle('hidden', step !== 4);

            for (let i = 1; i <= 3; i++) {
                const pill = document.getElementById('step-pill-' + i);
                if (pill) {
                    pill.className = 'step-pill w-7 h-7 rounded-full flex items-center justify-center font-bold text-xs transition-colors duration-300';
                    if (i < step) {
                        pill.classList.add('completed');
                        pill.innerHTML = '<i class="bi bi-check"></i>';
                    } else if (i === step) {
                        pill.classList.add('active');
                        pill.innerHTML = i;
                    } else {
                        pill.classList.add('bg-slate-200', 'text-slate-600');
                        pill.innerHTML = i;
                    }
                }
            }

            if (step === 2) {
                document.getElementById('display-target-email').textContent = verifiedEmail;
                setupOtpInputs();
                startCooldownTimer(45);
                startExpiryTimer(300);
            }
        }

        // ---------------- STEP 1: REQUEST OTP ----------------
        async function handleSendOtp(e) {
            e.preventDefault();
            hideAlert();

            const email = document.getElementById('emailInput').value.trim().toLowerCase();
            if (!email.endsWith('@niet.co.in')) {
                showAlert('Please use your official NIET college email ID ending with <strong>@niet.co.in</strong>.');
                return;
            }

            const btn = document.getElementById('send-otp-btn');
            btn.disabled = true;
            btn.innerHTML = '<i class="bi bi-arrow-repeat animate-spin"></i> <span>Sending OTP...</span>';

            try {
                const res = await fetch(contextPath + '/api/auth/forgot-password/request-otp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email, purpose: 'PASSWORD_RESET' })
                });
                const data = await res.json();

                if (data.success) {
                    verifiedEmail = email;
                    goToStep(2);
                    showAlert(data.message || 'OTP sent successfully to your NIET email.', 'success');
                } else {
                    showAlert(data.message || 'Failed to send OTP.');
                }
            } catch (err) {
                showAlert('Network error. Please verify your connection.');
            } finally {
                btn.disabled = false;
                btn.innerHTML = '<span>Send Verification OTP</span> <i class="bi bi-arrow-right"></i>';
            }
        }

        // ---------------- STEP 2: VERIFY OTP ----------------
        function setupOtpInputs() {
            const inputs = [
                document.getElementById('otp-1'),
                document.getElementById('otp-2'),
                document.getElementById('otp-3'),
                document.getElementById('otp-4'),
                document.getElementById('otp-5'),
                document.getElementById('otp-6')
            ];

            inputs.forEach(inp => inp.value = '');
            inputs[0].focus();

            inputs.forEach((inp, idx) => {
                inp.oninput = (e) => {
                    const val = e.target.value;
                    if (val.length === 1 && idx < 5) {
                        inputs[idx + 1].focus();
                    }
                };

                inp.onkeydown = (e) => {
                    if (e.key === 'Backspace' && !inp.value && idx > 0) {
                        inputs[idx - 1].focus();
                    }
                };

                inp.onpaste = (e) => {
                    e.preventDefault();
                    const pasteData = (e.clipboardData || window.clipboardData).getData('text').trim();
                    if (/^\d{6}$/.test(pasteData)) {
                        pasteData.split('').forEach((char, i) => {
                            if (inputs[i]) inputs[i].value = char;
                        });
                        inputs[5].focus();
                    }
                };
            });
        }

        function getEnteredOtp() {
            let otp = '';
            for (let i = 1; i <= 6; i++) {
                otp += document.getElementById('otp-' + i).value.trim();
            }
            return otp;
        }

        function startCooldownTimer(seconds) {
            clearInterval(cooldownInterval);
            const resendBtn = document.getElementById('resend-btn');
            const cooldownTimer = document.getElementById('cooldown-timer');
            resendBtn.disabled = true;
            resendBtn.className = 'text-slate-400 font-semibold cursor-not-allowed transition-colors';

            let rem = seconds;
            cooldownTimer.textContent = rem + 's';

            cooldownInterval = setInterval(() => {
                rem--;
                if (rem <= 0) {
                    clearInterval(cooldownInterval);
                    resendBtn.disabled = false;
                    resendBtn.className = 'text-niet-700 font-bold hover:underline cursor-pointer transition-colors';
                    resendBtn.innerHTML = 'Resend OTP';
                } else {
                    cooldownTimer.textContent = rem + 's';
                }
            }, 1000);
        }

        function startExpiryTimer(seconds) {
            clearInterval(expiryInterval);
            const expiryTimer = document.getElementById('expiry-timer');
            let rem = seconds;

            expiryInterval = setInterval(() => {
                rem--;
                if (rem <= 0) {
                    clearInterval(expiryInterval);
                    expiryTimer.textContent = '00:00 (Expired)';
                    expiryTimer.className = 'text-rose-600 font-bold';
                } else {
                    const mins = Math.floor(rem / 60);
                    const secs = rem % 60;
                    expiryTimer.textContent = (mins < 10 ? '0' : '') + mins + ':' + (secs < 10 ? '0' : '') + secs;
                }
            }, 1000);
        }

        async function handleResendOtp() {
            hideAlert();
            const resendBtn = document.getElementById('resend-btn');
            resendBtn.disabled = true;
            resendBtn.innerHTML = '<i class="bi bi-arrow-repeat animate-spin"></i> Resending...';

            try {
                const res = await fetch(contextPath + '/api/auth/forgot-password/request-otp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: verifiedEmail, purpose: 'PASSWORD_RESET' })
                });
                const data = await res.json();
                if (data.success) {
                    showAlert('A fresh OTP has been sent to your email.', 'success');
                    setupOtpInputs();
                    startCooldownTimer(45);
                    startExpiryTimer(300);
                } else {
                    showAlert(data.message || 'Failed to resend OTP.');
                    resendBtn.disabled = false;
                    resendBtn.innerHTML = 'Resend OTP';
                }
            } catch (err) {
                showAlert('Network error. Failed to resend OTP.');
                resendBtn.disabled = false;
                resendBtn.innerHTML = 'Resend OTP';
            }
        }

        async function handleVerifyOtp(e) {
            e.preventDefault();
            hideAlert();

            const otp = getEnteredOtp();
            if (otp.length !== 6 || !/^\d{6}$/.test(otp)) {
                showAlert('Please enter the complete 6-digit verification code.');
                return;
            }

            const btn = document.getElementById('verify-otp-btn');
            btn.disabled = true;
            btn.innerHTML = '<i class="bi bi-arrow-repeat animate-spin"></i> <span>Verifying...</span>';

            try {
                const res = await fetch(contextPath + '/api/auth/forgot-password/verify-otp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: verifiedEmail, otp: otp, purpose: 'PASSWORD_RESET' })
                });
                const data = await res.json();

                if (data.success) {
                    clearInterval(cooldownInterval);
                    clearInterval(expiryInterval);
                    goToStep(3);
                    showAlert('OTP verified! Please set your new password.', 'success');
                } else {
                    showAlert(data.message || 'Invalid or expired OTP.');
                }
            } catch (err) {
                showAlert('Network error. Please try again.');
            } finally {
                btn.disabled = false;
                btn.innerHTML = '<span>Verify Code</span> <i class="bi bi-check2-circle text-lg"></i>';
            }
        }

        // ---------------- STEP 3: RESET PASSWORD ----------------
        function togglePasswordVisibility(inputId, btn) {
            const input = document.getElementById(inputId);
            const icon = btn.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }

        function evaluatePasswordStrength(password) {
            let score = 0;
            const hasLen = password.length >= 8;
            const hasUpper = /[A-Z]/.test(password);
            const hasLower = /[a-z]/.test(password);
            const hasDigit = /\d/.test(password);

            updateCheckmark('req-len', hasLen);
            updateCheckmark('req-upper', hasUpper);
            updateCheckmark('req-lower', hasLower);
            updateCheckmark('req-digit', hasDigit);

            if (hasLen) score++;
            if (hasUpper) score++;
            if (hasLower) score++;
            if (hasDigit) score++;

            const bar = document.getElementById('strength-bar');
            const label = document.getElementById('strength-label');

            if (!password) {
                bar.style.width = '0%';
                label.textContent = 'Empty';
                label.className = 'text-slate-400';
            } else if (score <= 1) {
                bar.style.width = '25%';
                bar.className = 'h-full bg-rose-500 rounded-full transition-all duration-300';
                label.textContent = 'Weak';
                label.className = 'text-rose-600 font-bold';
            } else if (score === 2) {
                bar.style.width = '50%';
                bar.className = 'h-full bg-amber-500 rounded-full transition-all duration-300';
                label.textContent = 'Fair';
                label.className = 'text-amber-600 font-bold';
            } else if (score === 3) {
                bar.style.width = '75%';
                bar.className = 'h-full bg-blue-500 rounded-full transition-all duration-300';
                label.textContent = 'Good';
                label.className = 'text-blue-600 font-bold';
            } else {
                bar.style.width = '100%';
                bar.className = 'h-full bg-emerald-500 rounded-full transition-all duration-300';
                label.textContent = 'Strong';
                label.className = 'text-emerald-600 font-bold';
            }
        }

        function updateCheckmark(elemId, isValid) {
            const elem = document.getElementById(elemId);
            if (!elem) return;
            if (isValid) {
                elem.className = 'flex items-center gap-1.5 text-emerald-600 font-semibold';
                elem.querySelector('i').className = 'bi bi-check-circle-fill text-emerald-600';
            } else {
                elem.className = 'flex items-center gap-1.5 text-slate-500';
                elem.querySelector('i').className = 'bi bi-circle text-slate-300';
            }
        }

        async function handleResetPassword(e) {
            e.preventDefault();
            hideAlert();

            const pwd = document.getElementById('newPasswordInput').value;
            const confirm = document.getElementById('confirmPasswordInput').value;

            if (pwd.length < 8) {
                showAlert('Password must be at least 8 characters long.');
                return;
            }
            if (pwd !== confirm) {
                showAlert('Passwords do not match. Please re-enter carefully.');
                return;
            }

            const btn = document.getElementById('reset-pwd-btn');
            btn.disabled = true;
            btn.innerHTML = '<i class="bi bi-arrow-repeat animate-spin"></i> <span>Updating Password...</span>';

            try {
                const res = await fetch(contextPath + '/api/auth/forgot-password/reset', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        email: verifiedEmail,
                        newPassword: pwd,
                        confirmPassword: confirm
                    })
                });
                const data = await res.json();

                if (data.success) {
                    goToStep(4);
                } else {
                    showAlert(data.message || 'Failed to update password.');
                }
            } catch (err) {
                showAlert('Network error. Failed to reset password.');
            } finally {
                btn.disabled = false;
                btn.innerHTML = '<span>Update Password</span> <i class="bi bi-shield-check"></i>';
            }
        }
    </script>
</body>
</html>
