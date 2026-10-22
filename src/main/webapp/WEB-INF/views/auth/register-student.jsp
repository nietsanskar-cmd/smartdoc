<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Create NIET Account &bull; NIET Student Document Management System</title>
    
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
                <h1 class="font-display font-extrabold text-2xl sm:text-3xl text-slate-950 tracking-tight">Create Your NIET Account</h1>
                <p class="text-xs sm:text-sm text-slate-500 mt-1">Register using your official NIET college email ID</p>

                <!-- Step Indicators -->
                <div class="flex items-center justify-center gap-2 sm:gap-4 mt-6 max-w-md mx-auto">
                    <div class="flex items-center gap-1.5 text-xs font-bold" id="stepIndicator1">
                        <span class="step-pill active w-7 h-7 rounded-full flex items-center justify-center text-xs" id="pill1">1</span>
                        <span class="hidden sm:inline text-slate-700" id="label1">College ID</span>
                    </div>
                    <div class="w-6 sm:w-10 h-0.5 bg-slate-200" id="line1"></div>
                    <div class="flex items-center gap-1.5 text-xs font-bold" id="stepIndicator2">
                        <span class="step-pill bg-slate-200 text-slate-500 w-7 h-7 rounded-full flex items-center justify-center text-xs" id="pill2">2</span>
                        <span class="hidden sm:inline text-slate-400" id="label2">Verify OTP</span>
                    </div>
                    <div class="w-6 sm:w-10 h-0.5 bg-slate-200" id="line2"></div>
                    <div class="flex items-center gap-1.5 text-xs font-bold" id="stepIndicator3">
                        <span class="step-pill bg-slate-200 text-slate-500 w-7 h-7 rounded-full flex items-center justify-center text-xs" id="pill3">3</span>
                        <span class="hidden sm:inline text-slate-400" id="label3">Password</span>
                    </div>
                    <div class="w-6 sm:w-10 h-0.5 bg-slate-200" id="line3"></div>
                    <div class="flex items-center gap-1.5 text-xs font-bold" id="stepIndicator4">
                        <span class="step-pill bg-slate-200 text-slate-500 w-7 h-7 rounded-full flex items-center justify-center text-xs" id="pill4">4</span>
                        <span class="hidden sm:inline text-slate-400" id="label4">Complete</span>
                    </div>
                </div>
            </div>

            <!-- Wizard Card -->
            <div class="glass-card rounded-3xl p-7 sm:p-9 shadow-2xl relative">
                
                <!-- Notification / Alert Box -->
                <div id="alertBox" class="hidden mb-6 p-3.5 rounded-xl text-xs flex items-start gap-2.5">
                    <i id="alertIcon" class="bi mt-0.5 text-sm"></i>
                    <div id="alertMessage" class="flex-1 font-medium"></div>
                </div>

                <!-- ================= STEP 1: ENTER COLLEGE EMAIL ================= -->
                <div id="step1Container">
                    <form id="step1Form" class="space-y-4">
                        <div>
                            <label for="collegeEmail" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">
                                Official NIET College Email ID *
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                                    <i class="bi bi-envelope"></i>
                                </div>
                                <input type="email"
                                       id="collegeEmail"
                                       required
                                       placeholder="e.g. 23cse001@niet.co.in"
                                       class="w-full pl-10 pr-4 py-3 bg-slate-50/70 border border-slate-300 rounded-xl text-sm text-slate-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-niet-600 transition-all placeholder:text-slate-400" />
                            </div>
                            <div class="flex justify-between items-center mt-1.5">
                                <span class="text-[11px] text-slate-500">Allowed domain: <strong>@niet.co.in</strong></span>
                                <span id="emailDomainStatus" class="text-[11px]"></span>
                            </div>
                        </div>

                        <div class="p-3.5 rounded-xl bg-slate-50 border border-slate-200 text-slate-600 text-xs flex items-start gap-2.5">
                            <i class="bi bi-info-circle text-niet-700 text-sm mt-0.5"></i>
                            <span>A 6-digit verification code will be sent to your official NIET inbox from <strong>sdmsniet@gmail.com</strong>.</span>
                        </div>

                        <button type="submit"
                                id="sendOtpBtn"
                                class="w-full py-3 px-4 rounded-xl font-display font-bold text-sm btn-niet flex items-center justify-center gap-2 mt-2">
                            <span id="sendOtpText">Send Verification OTP</span>
                            <i class="bi bi-arrow-right" id="sendOtpIcon"></i>
                        </button>
                    </form>
                </div>

                <!-- ================= STEP 2: VERIFY OTP ================= -->
                <div id="step2Container" class="hidden space-y-6">
                    <div class="text-center">
                        <div class="w-12 h-12 rounded-2xl bg-niet-50 text-niet-700 flex items-center justify-center mx-auto text-xl mb-2">
                            <i class="bi bi-shield-lock-fill"></i>
                        </div>
                        <h3 class="font-display font-extrabold text-xl text-slate-950">Verify Your College Email</h3>
                        <p class="text-xs text-slate-500 mt-1">
                            We've sent a 6-digit verification code to <br/>
                            <strong class="text-slate-900 font-semibold" id="displayTargetEmail">student@niet.co.in</strong>
                        </p>
                    </div>

                    <!-- 6-Box OTP Inputs -->
                    <div class="flex justify-center items-center gap-2 sm:gap-3 py-2" id="otpBoxContainer">
                        <input type="text" maxlength="1" class="otp-input" id="otp1" inputmode="numeric" autocomplete="one-time-code" autofocus />
                        <input type="text" maxlength="1" class="otp-input" id="otp2" inputmode="numeric" />
                        <input type="text" maxlength="1" class="otp-input" id="otp3" inputmode="numeric" />
                        <input type="text" maxlength="1" class="otp-input" id="otp4" inputmode="numeric" />
                        <input type="text" maxlength="1" class="otp-input" id="otp5" inputmode="numeric" />
                        <input type="text" maxlength="1" class="otp-input" id="otp6" inputmode="numeric" />
                    </div>

                    <div class="flex justify-between items-center text-xs text-slate-500 px-1">
                        <span>Code expires in <strong>5 minutes</strong></span>
                        <div id="resendContainer">
                            <span id="cooldownText" class="text-slate-400">Resend OTP in <strong id="countdownSeconds">45</strong>s</span>
                            <button type="button" id="resendOtpBtn" class="hidden font-bold text-niet-700 hover:text-niet-800 hover:underline">
                                Resend OTP
                            </button>
                        </div>
                    </div>

                    <div class="flex gap-3">
                        <button type="button" id="backToStep1Btn" class="w-1/3 py-3 px-4 rounded-xl font-bold text-xs bg-slate-100 hover:bg-slate-200 text-slate-700 transition-colors">
                            <i class="bi bi-arrow-left me-1"></i> Edit Email
                        </button>
                        <button type="button" id="verifyOtpBtn" class="flex-1 py-3 px-4 rounded-xl font-display font-bold text-sm btn-niet flex items-center justify-center gap-2">
                            <span id="verifyOtpText">Verify OTP</span>
                            <i class="bi bi-check2-circle"></i>
                        </button>
                    </div>
                </div>

                <!-- ================= STEP 3: CREATE PASSWORD ================= -->
                <div id="step3Container" class="hidden">
                    <div class="text-center mb-5">
                        <h3 class="font-display font-extrabold text-xl text-slate-950">Create Your Password</h3>
                        <p class="text-xs text-slate-500 mt-1">Set a secure password for your NIET SDMS account</p>
                    </div>

                    <form id="step3Form" class="space-y-4">
                        <div class="grid grid-cols-2 gap-3">
                            <div>
                                <label for="firstNameInput" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1">
                                    First Name
                                </label>
                                <input type="text" id="firstNameInput" placeholder="e.g. Aarav" class="w-full px-3.5 py-2.5 bg-slate-50/70 border border-slate-300 rounded-xl text-sm text-slate-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-niet-600 transition-all placeholder:text-slate-400" />
                            </div>
                            <div>
                                <label for="lastNameInput" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1">
                                    Last Name
                                </label>
                                <input type="text" id="lastNameInput" placeholder="e.g. Sharma" class="w-full px-3.5 py-2.5 bg-slate-50/70 border border-slate-300 rounded-xl text-sm text-slate-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-niet-600 transition-all placeholder:text-slate-400" />
                            </div>
                        </div>

                        <div>
                            <label for="rollNoInput" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1">
                                University / College Roll Number *
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                                    <i class="bi bi-person-vcard"></i>
                                </div>
                                <input type="text"
                                       id="rollNoInput"
                                       required
                                       placeholder="e.g. 0241MCSD011 or 2301330100123"
                                       class="w-full pl-10 pr-4 py-2.5 bg-slate-50/70 border border-slate-300 rounded-xl text-sm text-slate-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-niet-600 transition-all placeholder:text-slate-400 uppercase" />
                            </div>
                            <span class="text-[11px] text-slate-400 mt-0.5 block">Official NIET / AKTU student roll number</span>
                        </div>

                        <div>
                            <label for="newPassword" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1">
                                Password *
                            </label>
                            <div class="relative">
                                <input type="password" id="newPassword" required placeholder="Minimum 8 characters" class="w-full pl-3.5 pr-10 py-2.5 bg-slate-50/70 border border-slate-300 rounded-xl text-sm text-slate-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-niet-600 transition-all placeholder:text-slate-400" />
                                <button type="button" id="toggleNewPassword" class="absolute inset-y-0 right-0 pr-3 flex items-center text-slate-400 hover:text-slate-600">
                                    <i class="bi bi-eye" id="eyeIconNew"></i>
                                </button>
                            </div>

                            <!-- Password Strength Indicator -->
                            <div class="mt-2">
                                <div class="flex justify-between items-center text-[11px] mb-1">
                                    <span class="text-slate-500">Password Strength:</span>
                                    <span id="strengthText" class="font-bold text-slate-400">Too Short</span>
                                </div>
                                <div class="w-full bg-slate-200 h-1.5 rounded-full overflow-hidden">
                                    <div id="strengthBar" class="h-full w-0 transition-all duration-300 bg-rose-500"></div>
                                </div>
                            </div>
                        </div>

                        <div>
                            <label for="confirmPassword" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1">
                                Confirm Password *
                            </label>
                            <div class="relative">
                                <input type="password" id="confirmPassword" required placeholder="Re-enter your password" class="w-full pl-3.5 pr-10 py-2.5 bg-slate-50/70 border border-slate-300 rounded-xl text-sm text-slate-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-niet-600 transition-all placeholder:text-slate-400" />
                                <button type="button" id="toggleConfirmPassword" class="absolute inset-y-0 right-0 pr-3 flex items-center text-slate-400 hover:text-slate-600">
                                    <i class="bi bi-eye" id="eyeIconConfirm"></i>
                                </button>
                            </div>
                            <span id="matchFeedback" class="text-[11px] mt-1 block text-slate-400"></span>
                        </div>

                        <!-- Requirements Checklist -->
                        <div class="p-3 rounded-xl bg-slate-50 border border-slate-200 text-[11px] space-y-1 text-slate-600">
                            <div id="reqLength" class="flex items-center gap-1.5"><i class="bi bi-circle text-slate-400"></i> At least 8 characters</div>
                            <div id="reqUpper" class="flex items-center gap-1.5"><i class="bi bi-circle text-slate-400"></i> At least one uppercase letter (A-Z)</div>
                            <div id="reqLower" class="flex items-center gap-1.5"><i class="bi bi-circle text-slate-400"></i> At least one lowercase letter (a-z)</div>
                            <div id="reqNumber" class="flex items-center gap-1.5"><i class="bi bi-circle text-slate-400"></i> At least one number (0-9)</div>
                            <div id="reqSpecial" class="flex items-center gap-1.5"><i class="bi bi-circle text-slate-400"></i> At least one special character (@$!%*?&_#)</div>
                        </div>

                        <button type="submit"
                                id="createAccountBtn"
                                class="w-full py-3 px-4 rounded-xl font-display font-bold text-sm btn-niet flex items-center justify-center gap-2 mt-2">
                            <span id="createAccountText">Create Account</span>
                            <i class="bi bi-person-check-fill"></i>
                        </button>
                    </form>
                </div>

                <!-- ================= STEP 4: COMPLETE ================= -->
                <div id="step4Container" class="hidden text-center space-y-5 py-4">
                    <div class="w-16 h-16 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center mx-auto text-3xl shadow-sm">
                        <i class="bi bi-check-lg"></i>
                    </div>

                    <div>
                        <h3 class="font-display font-extrabold text-2xl text-slate-950">Account Created Successfully</h3>
                        <p class="text-xs sm:text-sm text-slate-600 mt-1">Your NIET SDMS account has been created and verified.</p>
                    </div>

                    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200/80 max-w-sm mx-auto text-left">
                        <div class="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Registered College ID</div>
                        <div class="text-sm font-bold text-slate-900 font-mono mt-0.5" id="finalEmailDisplay">23cse001@niet.co.in</div>
                        <div class="text-[11px] text-emerald-600 font-semibold mt-1"><i class="bi bi-shield-check me-1"></i>Official NIET Student Account</div>
                    </div>

                    <div class="text-xs text-slate-500">
                        Redirecting to Student Portal in <strong id="redirectCount" class="text-niet-700 font-bold">2</strong> seconds...
                    </div>

                    <a id="dashboardRedirectBtn" href="<c:url value='/student/dashboard'/>"
                       class="w-full py-3 px-4 rounded-xl font-display font-bold text-sm btn-niet inline-flex items-center justify-center gap-2 max-w-sm mx-auto">
                        <span>Go to Student Portal Now</span>
                        <i class="bi bi-arrow-right"></i>
                    </a>
                </div>

            </div>

        </div>
    </main>

    <!-- Footer -->
    <footer class="relative z-10 w-full px-6 py-4 text-center text-xs text-slate-500 max-w-7xl mx-auto border-t border-slate-200/60">
        <div>&copy; 2026 Noida Institute of Engineering and Technology (NIET), Greater Noida. All Rights Reserved.</div>
        <div class="text-[11px] text-slate-400 mt-0.5">Autonomous Institute &bull; Affiliated to Dr. A.P.J. Abdul Kalam Technical University, Lucknow</div>
    </footer>

    <!-- Interactive Wizard JavaScript -->
    <script>
        let currentEmail = '';
        let cooldownInterval = null;

        // Elements
        const alertBox = document.getElementById('alertBox');
        const alertIcon = document.getElementById('alertIcon');
        const alertMessage = document.getElementById('alertMessage');

        const step1Container = document.getElementById('step1Container');
        const step2Container = document.getElementById('step2Container');
        const step3Container = document.getElementById('step3Container');
        const step4Container = document.getElementById('step4Container');

        const collegeEmail = document.getElementById('collegeEmail');
        const emailDomainStatus = document.getElementById('emailDomainStatus');
        const sendOtpBtn = document.getElementById('sendOtpBtn');
        const sendOtpText = document.getElementById('sendOtpText');
        const sendOtpIcon = document.getElementById('sendOtpIcon');

        const displayTargetEmail = document.getElementById('displayTargetEmail');
        const verifyOtpBtn = document.getElementById('verifyOtpBtn');
        const verifyOtpText = document.getElementById('verifyOtpText');
        const resendOtpBtn = document.getElementById('resendOtpBtn');
        const cooldownText = document.getElementById('cooldownText');
        const countdownSeconds = document.getElementById('countdownSeconds');
        const backToStep1Btn = document.getElementById('backToStep1Btn');

        const step3Form = document.getElementById('step3Form');
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        const createAccountBtn = document.getElementById('createAccountBtn');
        const createAccountText = document.getElementById('createAccountText');
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        const matchFeedback = document.getElementById('matchFeedback');
        const finalEmailDisplay = document.getElementById('finalEmailDisplay');

        function showAlert(msg, isError = true) {
            alertBox.className = isError
                ? 'mb-6 p-3.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-xs flex items-start gap-2.5 animate-shake'
                : 'mb-6 p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-start gap-2.5';
            alertIcon.className = isError
                ? 'bi bi-exclamation-triangle-fill text-rose-600 mt-0.5 text-sm'
                : 'bi bi-check-circle-fill text-emerald-600 mt-0.5 text-sm';
            alertMessage.innerText = msg;
            alertBox.classList.remove('hidden');
        }

        function hideAlert() {
            alertBox.classList.add('hidden');
        }

        function setStep(step) {
            hideAlert();
            for (let i = 1; i <= 4; i++) {
                const pill = document.getElementById('pill' + i);
                const label = document.getElementById('label' + i);
                if (i < step) {
                    pill.className = 'step-pill completed w-7 h-7 rounded-full flex items-center justify-center text-xs';
                    pill.innerHTML = '<i class="bi bi-check"></i>';
                    if (label) label.className = 'hidden sm:inline text-slate-700';
                } else if (i === step) {
                    pill.className = 'step-pill active w-7 h-7 rounded-full flex items-center justify-center text-xs';
                    pill.innerText = i;
                    if (label) label.className = 'hidden sm:inline font-bold text-slate-900';
                } else {
                    pill.className = 'step-pill bg-slate-200 text-slate-500 w-7 h-7 rounded-full flex items-center justify-center text-xs';
                    pill.innerText = i;
                    if (label) label.className = 'hidden sm:inline text-slate-400';
                }
            }

            step1Container.classList.toggle('hidden', step !== 1);
            step2Container.classList.toggle('hidden', step !== 2);
            step3Container.classList.toggle('hidden', step !== 3);
            step4Container.classList.toggle('hidden', step !== 4);

            if (step === 2) {
                document.getElementById('otp1').focus();
            } else if (step === 3) {
                newPassword.focus();
            }
        }

        collegeEmail.addEventListener('input', () => {
            const val = collegeEmail.value.trim().toLowerCase();
            if (val.includes('@')) {
                if (val.endsWith('@niet.co.in')) {
                    emailDomainStatus.innerHTML = '<span class="text-emerald-600 font-semibold"><i class="bi bi-check-circle me-0.5"></i>Valid NIET domain</span>';
                } else if (val.endsWith('@gmail.com') || val.endsWith('@yahoo.com') || val.endsWith('@outlook.com')) {
                    emailDomainStatus.innerHTML = '<span class="text-rose-600 font-semibold"><i class="bi bi-x-circle me-0.5"></i>@niet.co.in required</span>';
                } else {
                    emailDomainStatus.innerHTML = '';
                }
            } else {
                emailDomainStatus.innerHTML = '';
            }
        });

        document.getElementById('step1Form').addEventListener('submit', async (e) => {
            e.preventDefault();
            hideAlert();

            const email = collegeEmail.value.trim().toLowerCase();
            if (!email.endsWith('@niet.co.in')) {
                showAlert('Please use your official NIET college email ID ending with @niet.co.in.');
                return;
            }

            sendOtpBtn.disabled = true;
            sendOtpText.innerText = 'Sending OTP...';
            sendOtpIcon.className = 'bi bi-arrow-repeat animate-spin';

            try {
                const res = await fetch('<c:url value="/api/auth/register/request-otp"/>', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email, purpose: 'REGISTRATION' })
                });
                const data = await res.json();

                if (res.ok && data.success) {
                    currentEmail = email;
                    displayTargetEmail.innerText = email;
                    setStep(2);
                    startCooldownTimer(45);
                } else {
                    showAlert(data.message || 'We couldn\'t send the verification email. Please try again.');
                }
            } catch (err) {
                showAlert('Network error. Please try again.');
            } finally {
                sendOtpBtn.disabled = false;
                sendOtpText.innerText = 'Send Verification OTP';
                sendOtpIcon.className = 'bi bi-arrow-right';
            }
        });

        const otpInputs = [
            document.getElementById('otp1'),
            document.getElementById('otp2'),
            document.getElementById('otp3'),
            document.getElementById('otp4'),
            document.getElementById('otp5'),
            document.getElementById('otp6')
        ];

        otpInputs.forEach((input, index) => {
            input.addEventListener('input', (e) => {
                const val = e.target.value.replace(/\D/g, '');
                e.target.value = val ? val.charAt(0) : '';

                if (val && index < 5) {
                    otpInputs[index + 1].focus();
                }
            });

            input.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && !input.value && index > 0) {
                    otpInputs[index - 1].focus();
                }
            });

            input.addEventListener('paste', (e) => {
                e.preventDefault();
                const pasteData = (e.clipboardData || window.clipboardData).getData('text').trim().replace(/\D/g, '');
                if (pasteData.length > 0) {
                    for (let i = 0; i < 6; i++) {
                        otpInputs[i].value = pasteData[i] || '';
                    }
                    const nextIndex = Math.min(pasteData.length, 5);
                    otpInputs[nextIndex].focus();
                }
            });
        });

        function getFullOtp() {
            return otpInputs.map(i => i.value).join('');
        }

        function clearOtp() {
            otpInputs.forEach(i => i.value = '');
            otpInputs[0].focus();
        }

        verifyOtpBtn.addEventListener('click', async () => {
            hideAlert();
            const otp = getFullOtp();

            if (otp.length !== 6) {
                showAlert('Please enter all 6 digits of the verification code.');
                return;
            }

            verifyOtpBtn.disabled = true;
            verifyOtpText.innerText = 'Verifying...';

            try {
                const res = await fetch('<c:url value="/api/auth/register/verify-otp"/>', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: currentEmail, otp: otp, purpose: 'REGISTRATION' })
                });
                const data = await res.json();

                if (res.ok && data.success) {
                    setStep(3);
                } else {
                    showAlert(data.message || 'Invalid verification code. Please try again.');
                    clearOtp();
                }
            } catch (err) {
                showAlert('Verification request failed. Please try again.');
            } finally {
                verifyOtpBtn.disabled = false;
                verifyOtpText.innerText = 'Verify OTP';
            }
        });

        function startCooldownTimer(seconds) {
            let left = seconds;
            cooldownText.classList.remove('hidden');
            resendOtpBtn.classList.add('hidden');
            countdownSeconds.innerText = left;

            if (cooldownInterval) clearInterval(cooldownInterval);

            cooldownInterval = setInterval(() => {
                left--;
                countdownSeconds.innerText = left;
                if (left <= 0) {
                    clearInterval(cooldownInterval);
                    cooldownText.classList.add('hidden');
                    resendOtpBtn.classList.remove('hidden');
                }
            }, 1000);
        }

        resendOtpBtn.addEventListener('click', async () => {
            hideAlert();
            clearOtp();
            try {
                const res = await fetch('<c:url value="/api/auth/register/request-otp"/>', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: currentEmail, purpose: 'REGISTRATION' })
                });
                const data = await res.json();
                if (res.ok && data.success) {
                    showAlert('A new verification code has been dispatched to your email.', false);
                    startCooldownTimer(45);
                } else {
                    showAlert(data.message || 'Could not resend OTP.');
                }
            } catch (err) {
                showAlert('Failed to resend OTP.');
            }
        });

        backToStep1Btn.addEventListener('click', () => {
            setStep(1);
        });

        function checkPasswordStrength(p) {
            let score = 0;
            const hasLength = p.length >= 8;
            const hasUpper = /[A-Z]/.test(p);
            const hasLower = /[a-z]/.test(p);
            const hasNumber = /\d/.test(p);
            const hasSpecial = /[@$!%*?&_#^~+=<>.-]/.test(p);

            updateReq('reqLength', hasLength);
            updateReq('reqUpper', hasUpper);
            updateReq('reqLower', hasLower);
            updateReq('reqNumber', hasNumber);
            updateReq('reqSpecial', hasSpecial);

            if (hasLength) score++;
            if (hasUpper) score++;
            if (hasLower) score++;
            if (hasNumber) score++;
            if (hasSpecial) score++;

            if (score <= 2) {
                strengthBar.className = 'h-full transition-all duration-300 bg-rose-500';
                strengthBar.style.width = '33%';
                strengthText.className = 'font-bold text-rose-600';
                strengthText.innerText = 'Weak';
            } else if (score <= 4) {
                strengthBar.className = 'h-full transition-all duration-300 bg-amber-500';
                strengthBar.style.width = '66%';
                strengthText.className = 'font-bold text-amber-600';
                strengthText.innerText = 'Medium';
            } else {
                strengthBar.className = 'h-full transition-all duration-300 bg-emerald-500';
                strengthBar.style.width = '100%';
                strengthText.className = 'font-bold text-emerald-600';
                strengthText.innerText = 'Strong';
            }
            return score === 5;
        }

        function updateReq(id, valid) {
            const el = document.getElementById(id);
            if (valid) {
                el.className = 'flex items-center gap-1.5 text-emerald-600 font-medium';
                el.querySelector('i').className = 'bi bi-check-circle-fill text-emerald-600';
            } else {
                el.className = 'flex items-center gap-1.5 text-slate-600';
                el.querySelector('i').className = 'bi bi-circle text-slate-400';
            }
        }

        newPassword.addEventListener('input', () => {
            checkPasswordStrength(newPassword.value);
            checkMatch();
        });

        confirmPassword.addEventListener('input', checkMatch);

        function checkMatch() {
            if (!confirmPassword.value) {
                matchFeedback.innerText = '';
                return false;
            }
            if (newPassword.value === confirmPassword.value) {
                matchFeedback.innerHTML = '<span class="text-emerald-600 font-semibold"><i class="bi bi-check-circle me-1"></i>Passwords match</span>';
                return true;
            } else {
                matchFeedback.innerHTML = '<span class="text-rose-600 font-semibold"><i class="bi bi-x-circle me-1"></i>Passwords do not match</span>';
                return false;
            }
        }

        document.getElementById('toggleNewPassword').addEventListener('click', () => {
            const eye = document.getElementById('eyeIconNew');
            if (newPassword.type === 'password') {
                newPassword.type = 'text';
                eye.className = 'bi bi-eye-slash';
            } else {
                newPassword.type = 'password';
                eye.className = 'bi bi-eye';
            }
        });

        document.getElementById('toggleConfirmPassword').addEventListener('click', () => {
            const eye = document.getElementById('eyeIconConfirm');
            if (confirmPassword.type === 'password') {
                confirmPassword.type = 'text';
                eye.className = 'bi bi-eye-slash';
            } else {
                confirmPassword.type = 'password';
                eye.className = 'bi bi-eye';
            }
        });

        step3Form.addEventListener('submit', async (e) => {
            e.preventDefault();
            hideAlert();

            if (!checkPasswordStrength(newPassword.value)) {
                showAlert('Please create a stronger password meeting all listed criteria.');
                return;
            }

            if (newPassword.value !== confirmPassword.value) {
                showAlert('Passwords do not match.');
                return;
            }

            createAccountBtn.disabled = true;
            createAccountText.innerText = 'Creating Account...';

            const payload = {
                email: currentEmail,
                password: newPassword.value,
                confirmPassword: confirmPassword.value,
                firstName: document.getElementById('firstNameInput').value.trim(),
                lastName: document.getElementById('lastNameInput').value.trim(),
                rollNo: document.getElementById('rollNoInput') ? document.getElementById('rollNoInput').value.trim().toUpperCase() : ''
            };

            try {
                const res = await fetch('<c:url value="/api/auth/register/create-password"/>', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });
                const data = await res.json();

                if (res.ok && data.success) {
                    finalEmailDisplay.innerText = currentEmail;
                    setStep(4);
                    let seconds = 2;
                    const countEl = document.getElementById('redirectCount');
                    const timer = setInterval(() => {
                        seconds--;
                        if (countEl) countEl.innerText = seconds;
                        if (seconds <= 0) {
                            clearInterval(timer);
                            window.location.href = '<c:url value="/student/dashboard"/>';
                        }
                    }, 1000);
                } else {
                    showAlert(data.message || 'Failed to create account.');
                }
            } catch (err) {
                showAlert('Account creation failed. Please try again.');
            } finally {
                createAccountBtn.disabled = false;
                createAccountText.innerText = 'Create Account';
            }
        });
    </script>
</body>
</html>