<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Login &bull; NIET Student Document Management System</title>
    
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

        .ambient-glow-1 {
          position: absolute;
          top: -10%;
          left: 5%;
          width: 500px;
          height: 500px;
          background: radial-gradient(circle, rgba(215, 25, 32, 0.10) 0%, rgba(255, 241, 242, 0.25) 60%, transparent 80%);
          filter: blur(90px);
          pointer-events: none;
          z-index: 1;
        }

        .ambient-glow-2 {
          position: absolute;
          bottom: -10%;
          right: 5%;
          width: 500px;
          height: 500px;
          background: radial-gradient(circle, rgba(17, 24, 39, 0.06) 0%, rgba(241, 245, 249, 0.3) 60%, transparent 80%);
          filter: blur(90px);
          pointer-events: none;
          z-index: 1;
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

        .btn-niet:active {
          transform: translateY(0);
        }
    </style>
</head>
<body class="min-h-screen text-slate-800 antialiased flex flex-col justify-between relative selection:bg-niet-500 selection:text-white">

    <div class="ambient-glow-1"></div>
    <div class="ambient-glow-2"></div>

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

        <div class="hidden sm:flex items-center gap-3">
            <span class="text-xs font-semibold px-3 py-1.5 rounded-full bg-white/80 border border-slate-200 text-slate-600 shadow-sm backdrop-blur-md">
                <i class="bi bi-shield-check text-emerald-600 me-1"></i> NAAC 'A' Grade &bull; NBA Accredited
            </span>
        </div>
    </header>

    <!-- Main Content Container -->
    <main class="relative z-10 flex-1 flex items-center justify-center px-4 py-8 max-w-7xl mx-auto w-full">
        <div class="grid lg:grid-cols-12 gap-8 lg:gap-12 w-full max-w-5xl items-center">
            
            <!-- Left Column: Branding Showcase -->
            <div class="lg:col-span-6 flex flex-col justify-center space-y-6 text-center lg:text-left">
                <div class="inline-flex items-center gap-2 self-center lg:self-start px-3.5 py-1.5 rounded-full bg-niet-50 border border-niet-200/80 text-niet-700 text-xs font-bold tracking-wide">
                    <span class="w-2 h-2 rounded-full bg-niet-600 animate-pulse"></span>
                    Official Academic Document Portal
                </div>

                <h1 class="font-display font-extrabold text-3xl sm:text-4xl lg:text-5xl text-slate-950 tracking-tight leading-[1.15]">
                    Noida Institute of <br class="hidden sm:inline"/>
                    <span class="text-transparent bg-clip-text bg-gradient-to-r from-niet-700 to-niet-900">Engineering & Technology</span>
                </h1>

                <p class="text-slate-600 text-sm sm:text-base leading-relaxed max-w-lg mx-auto lg:mx-0">
                    Secure institutional cloud vault for academic marksheets, degree certificates, faculty review workflows, and cryptographic verifications.
                </p>

                <!-- Features Grid -->
                <div class="grid grid-cols-2 gap-3 pt-2 text-left max-w-md mx-auto lg:mx-0">
                    <div class="flex items-start gap-2.5 p-3 rounded-xl bg-white/70 border border-slate-200/80 shadow-xs">
                        <div class="p-2 rounded-lg bg-niet-50 text-niet-700 text-sm">
                            <i class="bi bi-envelope-check-fill"></i>
                        </div>
                        <div>
                            <h4 class="text-xs font-bold text-slate-900">@niet.co.in Access</h4>
                            <p class="text-[11px] text-slate-500">Official college emails only</p>
                        </div>
                    </div>
                    <div class="flex items-start gap-2.5 p-3 rounded-xl bg-white/70 border border-slate-200/80 shadow-xs">
                        <div class="p-2 rounded-lg bg-niet-50 text-niet-700 text-sm">
                            <i class="bi bi-shield-lock-fill"></i>
                        </div>
                        <div>
                            <h4 class="text-xs font-bold text-slate-900">SHA-256 Vault</h4>
                            <p class="text-[11px] text-slate-500">Tamper-proof storage</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Login Card -->
            <div class="lg:col-span-6 w-full max-w-md mx-auto">
                <div class="glass-card rounded-3xl p-7 sm:p-9 shadow-2xl relative overflow-hidden">
                    
                    <div class="text-center mb-6">
                        <h2 class="font-display font-extrabold text-2xl sm:text-3xl text-slate-950 tracking-tight">Welcome Back</h2>
                        <p class="text-xs sm:text-sm text-slate-500 mt-1">Sign in with your official NIET credentials</p>
                    </div>

                    <!-- Role Switcher Tabs (Dual Authentication Process) -->
                    <div class="flex p-1 bg-slate-100 rounded-2xl mb-6 border border-slate-200/80">
                        <button type="button" id="tabStudent" onclick="switchRole('STUDENT')"
                                class="flex-1 py-2 px-3 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1.5 bg-white text-niet-700 shadow-sm">
                            <i class="bi bi-mortarboard-fill"></i> Student Portal
                        </button>
                        <button type="button" id="tabFaculty" onclick="switchRole('FACULTY')"
                                class="flex-1 py-2 px-3 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1.5 text-slate-500 hover:text-slate-900">
                            <i class="bi bi-person-workspace"></i> Faculty Portal
                        </button>
                    </div>

                    <!-- Alerts -->
                    <c:if test="${not empty errorMessage}">
                        <div class="mb-5 p-3.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-xs flex items-start gap-2.5 animate-shake">
                            <i class="bi bi-exclamation-triangle-fill text-rose-600 text-sm mt-0.5"></i>
                            <div class="flex-1 font-medium"><c:out value="${errorMessage}"/></div>
                        </div>
                    </c:if>
                    <c:if test="${not empty successMessage}">
                        <div class="mb-5 p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-start gap-2.5">
                            <i class="bi bi-check-circle-fill text-emerald-600 text-sm mt-0.5"></i>
                            <div class="flex-1 font-medium"><c:out value="${successMessage}"/></div>
                        </div>
                    </c:if>
                    <c:if test="${not empty infoMessage}">
                        <div class="mb-5 p-3.5 rounded-xl bg-sky-50 border border-sky-200 text-sky-800 text-xs flex items-start gap-2.5">
                            <i class="bi bi-info-circle-fill text-sky-600 text-sm mt-0.5"></i>
                            <div class="flex-1 font-medium"><c:out value="${infoMessage}"/></div>
                        </div>
                    </c:if>

                    <div id="domainAlert" class="hidden mb-5 p-3 rounded-xl bg-amber-50 border border-amber-200 text-amber-900 text-xs flex items-start gap-2">
                        <i class="bi bi-exclamation-circle-fill text-amber-600 mt-0.5"></i>
                        <span id="domainAlertText">Please use your official NIET college email ID ending with <strong>@niet.co.in</strong>.</span>
                    </div>

                    <!-- Login Form -->
                    <form action="<c:url value='/login'/>" method="post" id="loginForm" class="space-y-4">
                        <div>
                            <label for="usernameInput" id="usernameLabel" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">
                                College Email ID / Roll No *
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                                    <i class="bi bi-envelope" id="usernameIcon"></i>
                                </div>
                                <input type="text"
                                       name="username"
                                       id="usernameInput"
                                       required
                                       placeholder="e.g. 0241mcsd011@niet.co.in"
                                       class="w-full pl-10 pr-4 py-2.5 bg-slate-50/70 border border-slate-300 rounded-xl text-sm text-slate-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-niet-600 transition-all placeholder:text-slate-400" />
                            </div>
                            <span id="domainFeedback" class="text-[11px] text-slate-400 mt-1 block">Allowed domain: @niet.co.in</span>
                        </div>

                        <div>
                            <div class="flex justify-between items-center mb-1.5">
                                <label for="passwordInput" class="block text-xs font-bold text-slate-700 uppercase tracking-wider">
                                    Password *
                                </label>
                                <a href="<c:url value='/forgot-password'/>" class="text-xs font-semibold text-niet-700 hover:text-niet-800 transition-colors">
                                    Forgot Password?
                                </a>
                            </div>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                                    <i class="bi bi-lock"></i>
                                </div>
                                <input type="password"
                                       name="password"
                                       id="passwordInput"
                                       required
                                       placeholder="Enter your account password"
                                       class="w-full pl-10 pr-10 py-2.5 bg-slate-50/70 border border-slate-300 rounded-xl text-sm text-slate-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-niet-600 focus:border-niet-600 transition-all placeholder:text-slate-400" />
                                <button type="button"
                                        id="togglePassword"
                                        class="absolute inset-y-0 right-0 pr-3.5 flex items-center text-slate-400 hover:text-slate-600">
                                    <i class="bi bi-eye" id="passwordEyeIcon"></i>
                                </button>
                            </div>
                        </div>

                        <button type="submit"
                                id="submitBtn"
                                class="w-full py-3 px-4 rounded-xl font-display font-bold text-sm btn-niet flex items-center justify-center gap-2 mt-2">
                            <span>Login to NIET SDMS</span>
                            <i class="bi bi-arrow-right"></i>
                        </button>
                    </form>

                    <!-- Registration Link -->
                    <div class="mt-6 pt-5 border-t border-slate-200/80 text-center">
                        <p class="text-xs text-slate-600">
                            Don't have an account?
                            <a href="<c:url value='/register'/>" class="font-bold text-niet-700 hover:text-niet-800 hover:underline ms-1">
                                Create NIET Account
                            </a>
                        </p>
                    </div>

                </div>
            </div>

        </div>
    </main>

    <!-- Footer -->
    <footer class="relative z-10 w-full px-6 py-4 text-center text-xs text-slate-500 max-w-7xl mx-auto border-t border-slate-200/60">
        <div>&copy; 2026 Noida Institute of Engineering and Technology (NIET), Greater Noida. All Rights Reserved.</div>
        <div class="text-[11px] text-slate-400 mt-0.5">Autonomous Institute &bull; Affiliated to Dr. A.P.J. Abdul Kalam Technical University, Lucknow</div>
    </footer>

    <!-- Client-side Domain Validation & UI Logic -->
    <script>
        const usernameInput = document.getElementById('usernameInput');
        const domainAlert = document.getElementById('domainAlert');
        const domainFeedback = document.getElementById('domainFeedback');
        const loginForm = document.getElementById('loginForm');
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('passwordInput');
        const passwordEyeIcon = document.getElementById('passwordEyeIcon');

        let currentRole = 'STUDENT';
        const tabStudent = document.getElementById('tabStudent');
        const tabFaculty = document.getElementById('tabFaculty');
        const usernameLabel = document.getElementById('usernameLabel');
        const usernameIcon = document.getElementById('usernameIcon');

        function switchRole(role) {
            currentRole = role;
            if (role === 'STUDENT') {
                tabStudent.className = 'flex-1 py-2 px-3 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1.5 bg-white text-niet-700 shadow-sm';
                tabFaculty.className = 'flex-1 py-2 px-3 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1.5 text-slate-500 hover:text-slate-900';
                usernameLabel.innerText = 'College Email ID / Roll No *';
                usernameInput.placeholder = 'e.g. 0241mcsd011@niet.co.in';
                usernameIcon.className = 'bi bi-envelope';
            } else {
                tabFaculty.className = 'flex-1 py-2 px-3 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1.5 bg-white text-niet-700 shadow-sm';
                tabStudent.className = 'flex-1 py-2 px-3 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1.5 text-slate-500 hover:text-slate-900';
                usernameLabel.innerText = 'Faculty Email ID / Employee Code *';
                usernameInput.placeholder = 'e.g. faculty.name@niet.co.in or EMP1024';
                usernameIcon.className = 'bi bi-person-badge';
            }
        }

        // Toggle password visibility
        togglePassword.addEventListener('click', () => {
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                passwordEyeIcon.className = 'bi bi-eye-slash';
            } else {
                passwordInput.type = 'password';
                passwordEyeIcon.className = 'bi bi-eye';
            }
        });

        // Real-time domain validation check
        usernameInput.addEventListener('input', () => {
            const val = usernameInput.value.trim().toLowerCase();
            if (val.includes('@')) {
                if (val.endsWith('@niet.co.in')) {
                    domainAlert.classList.add('hidden');
                    domainFeedback.innerHTML = '<span class="text-emerald-600 font-semibold"><i class="bi bi-check-circle me-1"></i>Valid NIET college domain</span>';
                } else if (val.endsWith('@gmail.com') || val.endsWith('@yahoo.com') || val.endsWith('@outlook.com') || val.endsWith('@hotmail.com')) {
                    domainAlert.classList.remove('hidden');
                    domainFeedback.innerHTML = '<span class="text-rose-600 font-semibold"><i class="bi bi-x-circle me-1"></i>Non-NIET domains are not allowed</span>';
                } else {
                    domainAlert.classList.add('hidden');
                    domainFeedback.innerHTML = 'Allowed domain: @niet.co.in';
                }
            } else {
                domainAlert.classList.add('hidden');
                domainFeedback.innerHTML = 'Allowed domain: @niet.co.in';
            }
        });

        // Form submit validation
        loginForm.addEventListener('submit', (e) => {
            const val = usernameInput.value.trim().toLowerCase();
            if (val.includes('@') && !val.endsWith('@niet.co.in')) {
                e.preventDefault();
                domainAlert.classList.remove('hidden');
                domainAlert.scrollIntoView({ behavior: 'smooth', block: 'center' });
                return false;
            }
        });
    </script>
</body>
</html>