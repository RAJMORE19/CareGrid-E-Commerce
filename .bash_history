              <h4>Free Home Pickup</h4>
              <p>Phlebotomist arrives within 60 mins</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 2: Express 6-Hour Turnaround -->
      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">⚡ 6-HOUR TURNAROUND</span>
            <div class="slide-title">Fast Express <span>Digital Reports.</span></div>
            <div class="slide-desc">Cold-chain specimen transport with automated barcode tracking and instant PDF WhatsApp alerts.</div>
            <a href="/orders.html" class="btn-slide-cta">Track Live Samples &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">📑</div>
            <div class="slide-meta">
              <h4>Doctor-Verified Reports</h4>
              <p>Smart NABL-certified PDF reports</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 3: Cash on Doorstep Collection -->
      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">💵 ZERO ADVANCE PAYMENT</span>
            <div class="slide-title">Pay On Collection, <span>Complete Trust.</span></div>
            <div class="slide-desc">Zero advance card fees. Hand cash or scan phlebotomist QR code after blood draw is complete.</div>
            <a href="/services.html" class="btn-slide-cta">Schedule Sample &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">💵</div>
            <div class="slide-meta">
              <h4>Cash on Collection</h4>
              <p>Pay collector after sample draw</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 4: Full Body & Preventive Screening -->
      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">🛡️ PREVENTIVE HEALTHCARE</span>
            <div class="slide-title">Full Body Health <span>Screening Checkup.</span></div>
            <div class="slide-desc">Cover vital markers: Heart, Liver, Kidney, Thyroid, Sugar, Vitamin D & B12 in one booking.</div>
            <a href="/services.html" class="btn-slide-cta">View Full Panels &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">🧪</div>
            <div class="slide-meta">
              <h4>Comprehensive Panels</h4>
              <p>Over 80+ essential biomarkers</p>
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- 4 Indicators -->
    <div class="carousel-indicators">
      <div class="c-dot active" onclick="setSlide(0)"></div>
      <div class="c-dot" onclick="setSlide(1)"></div>
      <div class="c-dot" onclick="setSlide(2)"></div>
      <div class="c-dot" onclick="setSlide(3)"></div>
    </div>
  </div>

  <!-- EXACTLY 3 POPULAR SERVICES SECTION -->
  <div class="main">
    <div class="section-header">
      <div class="section-title">Popular Diagnostic Packages</div>
      <div class="badge-pop">Top 3 Most Booked</div>
    </div>

    <div class="grid-3" id="homeGrid"></div>

    <div class="see-more-strip">
      <div>
        <b>Need Full Body or Specialized Panels?</b>
        <span style="color:#94a3b8; margin-left:6px;">Browse complete 35 test catalog (Heart, Liver, Kidney, Vitamins).</span>
      </div>
      <a href="/services.html" class="see-more-btn">View All 35 Services &rarr;</a>
    </div>
  </div>

  <footer>
    <div class="footer-container">
      <div>© 2026 CareGrid Healthcare Technologies Pvt Ltd. | Helpline: +91 6353468394 | rajmore2023@gmail.com</div>
      <div>SG Highway, Ahmedabad, Gujarat - 380054</div>
    </div>
  </footer>

  <script>
    // 1. ROTATE 4 CAROUSEL SLIDES EVERY 5 SECONDS (5000ms)
    let currentSlide = 0;
    const totalSlides = 4;
    const track = document.getElementById('track');
    const dots = document.querySelectorAll('.c-dot');

    function updateCarousel() {
      track.style.transform = `translateX(-${currentSlide * 25}%)`;
      dots.forEach((d, idx) => d.classList.toggle('active', idx === currentSlide));
    }

    function setSlide(idx) {
      currentSlide = idx;
      updateCarousel();
    }

    setInterval(() => {
      currentSlide = (currentSlide + 1) % totalSlides;
      updateCarousel();
    }, 5000); // exactly 5 seconds

    // 2. USER STATE & CART
    document.getElementById('userNameNav').innerText = localStorage.getItem('caregrid_user_name') || 'Raj More';
    let cart = JSON.parse(localStorage.getItem('caregrid_cart') || '[]');
    document.getElementById('cartBadge').innerText = cart.length;

    // 3. FETCH STRICTLY TOP 3 BOOKING SERVICES
    fetch('/api/catalog/products')
      .then(res => res.json())
      .then(data => {
        const grid = document.getElementById('homeGrid');
        grid.innerHTML = '';
        const top3 = data.tests.slice(0, 3);
        top3.forEach(test => {
          grid.innerHTML += `
            <div class="card">
              <div class="card-body">
                <span class="tag">${test.category}</span>
                <div class="title">${test.name}</div>
                <div class="desc">🩺 ${test.parameters}</div>
                <div class="price">${test.price}</div>
              </div>
              <div class="card-footer">
                <button class="btn-add" onclick="addToCart('${test.name}', ${test.numPrice})">Add to Cart</button>
                <button class="btn-book" onclick="bookNow('${test.name}', ${test.numPrice})">Instant Book</button>
              </div>
            </div>
          `;
        });
      });

    function addToCart(name, price) {
      cart.push({ name, price });
      localStorage.setItem('caregrid_cart', JSON.stringify(cart));
      document.getElementById('cartBadge').innerText = cart.length;
      alert(`✔ Added to Cart: ${name}\nRedirecting to Cart Service...`);
      window.location.href = '/cart.html';
    }

    function bookNow(name, price) {
      cart = [{ name, price }];
      localStorage.setItem('caregrid_cart', JSON.stringify(cart));
      window.location.href = '/checkout.html';
    }

    function logout(e) {
      e.preventDefault();
      localStorage.removeItem('caregrid_auth');
      window.location.href = '/login.html';
    }
  </script>
</body>
</html>
EOF

# Copy file directly into running container
docker cp index.html $(docker compose ps -q frontend):/usr/share/nginx/html/index.html
c
cd ~/frontend
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>CareGrid Diagnostics | Trusted Pathology Lab & Diagnostics</title>
  <script>
    if (localStorage.getItem('caregrid_auth') !== 'true') {
      window.location.replace('/login.html');
    }
  </script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif; }
    body { background: #f8fafc; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; font-size: 13.5px; }

    .topbar { background: #00172e; color: #94a3b8; font-size: 11.5px; padding: 6px 28px; display: flex; justify-content: space-between; align-items: center; }
    .topbar b { color: #f1f5f9; }
    .dot { width: 7px; height: 7px; border-radius: 50%; display: inline-block; background: #10b981; margin-right: 5px; box-shadow: 0 0 6px #10b981; }

    header { background: #ffffff; box-shadow: 0 2px 8px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100; }
    .nav { max-width: 1280px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; padding: 8px 24px; }
    .logo { font-size: 21px; font-weight: 800; color: #003366; text-decoration: none; display: flex; align-items: center; gap: 4px; }
    .logo span { color: #00a896; }
    .menu { display: flex; list-style: none; gap: 20px; font-weight: 600; font-size: 13.5px; }
    .menu a { color: #334155; text-decoration: none; }
    .menu a:hover { color: #00a896; }
    .actions { display: flex; gap: 10px; align-items: center; }
    .user-pill { background: #e6fffa; color: #003366; border: 1px solid #00a896; padding: 4px 12px; border-radius: 20px; font-weight: 700; font-size: 12.5px; text-decoration: none; display: flex; align-items: center; gap: 5px; }
    .btn-logout { background: none; border: none; color: #ef4444; font-size: 11px; font-weight: bold; cursor: pointer; text-decoration: underline; margin-left: 4px; }
    .btn-cart { background: #003366; color: white; padding: 5px 14px; border-radius: 20px; font-weight: 700; text-decoration: none; font-size: 12.5px; display: flex; gap: 5px; align-items: center; }
    .badge { background: #00a896; border-radius: 50%; padding: 2px 6px; font-size: 11px; }

    /* BALANCED MEDIUM HEIGHT 4-SLIDE CAROUSEL (ROTATES EVERY 3 SECONDS) */
    .carousel-wrapper {
      position: relative;
      background: linear-gradient(135deg, #001f3f 0%, #003366 50%, #004d61 100%);
      color: white;
      overflow: hidden;
      height: 200px;
    }
    .carousel-track {
      display: flex;
      transition: transform 0.5s cubic-bezier(0.25, 1, 0.5, 1);
      width: 400%;
      height: 100%;
    }
    .carousel-slide {
      width: 25%;
      height: 100%;
      padding: 18px 32px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .slide-inner {
      max-width: 1220px;
      width: 100%;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 24px;
    }
    .slide-left { flex: 1.2; }
    .badge-pill {
      display: inline-block;
      background: rgba(255, 255, 255, 0.12);
      border: 1px solid rgba(0, 168, 150, 0.6);
      padding: 2px 10px;
      border-radius: 20px;
      font-size: 11px;
      font-weight: 700;
      color: #5eead4;
      margin-bottom: 6px;
    }
    .slide-title { font-size: 22px; font-weight: 800; line-height: 1.2; margin-bottom: 4px; }
    .slide-title span { color: #38bdf8; }
    .slide-desc { font-size: 13px; color: #cbd5e1; margin-bottom: 12px; max-width: 530px; line-height: 1.35; }
    .btn-slide-cta {
      background: #00a896; color: white; text-decoration: none; font-weight: 700; font-size: 12.5px; padding: 7px 18px; border-radius: 18px; display: inline-block; box-shadow: 0 4px 10px rgba(0,168,150,0.3);
    }

    .slide-right-card {
      background: rgba(15, 23, 42, 0.55);
      border: 1px solid rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(8px);
      padding: 12px 18px;
      border-radius: 10px;
      display: flex;
      align-items: center;
      gap: 12px;
      min-width: 290px;
    }
    .slide-icon { width: 38px; height: 38px; border-radius: 8px; background: rgba(0, 168, 150, 0.25); display: flex; align-items: center; justify-content: center; font-size: 19px; flex-shrink: 0; }
    .slide-meta h4 { font-size: 13.5px; font-weight: 700; color: #fff; margin-bottom: 2px; }
    .slide-meta p { font-size: 11.5px; color: #94a3b8; }

    .carousel-indicators {
      position: absolute;
      bottom: 6px;
      left: 50%;
      transform: translateX(-50%);
      display: flex;
      gap: 6px;
    }
    .c-dot { width: 7px; height: 7px; border-radius: 50%; background: rgba(255,255,255,0.3); transition: 0.3s; cursor: pointer; }
    .c-dot.active { width: 18px; border-radius: 8px; background: #00a896; }

    /* EXACT 3 CARDS IN ONE ROW FOR LAPTOP VIEWPORT */
    .main { max-width: 1280px; width: 100%; margin: 14px auto 20px; padding: 0 24px; flex: 1; }
    .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
    .section-title { font-size: 18px; font-weight: 800; color: #003366; }
    .badge-pop { background: #e6fffa; color: #00a896; font-size: 11px; font-weight: 800; padding: 3px 9px; border-radius: 16px; border: 1px solid #99f6e4; }

    .grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; }
    @media (max-width: 850px) { .grid-3 { grid-template-columns: 1fr; } }

    .card { background: white; border-radius: 10px; border: 1px solid #e2e8f0; box-shadow: 0 2px 5px rgba(0,0,0,0.03); display: flex; flex-direction: column; justify-content: space-between; transition: 0.2s; }
    .card:hover { transform: translateY(-2px); box-shadow: 0 6px 14px rgba(0,0,0,0.06); border-color: #00a896; }
    .card-body { padding: 15px; }
    .tag { background: #e6fffa; color: #00a896; font-size: 10px; font-weight: 800; text-transform: uppercase; padding: 2px 7px; border-radius: 3px; display: inline-block; margin-bottom: 6px; }
    .title { font-size: 15px; font-weight: 700; color: #003366; margin-bottom: 4px; }
    .desc { font-size: 11.5px; color: #64748b; margin-bottom: 8px; line-height: 1.35; min-height: 30px; }
    .price { font-size: 20px; font-weight: 800; color: #003366; border-top: 1px solid #f1f5f9; padding-top: 8px; }
    .card-footer { padding: 10px 15px; background: #f8fafc; border-top: 1px solid #f1f5f9; display: flex; gap: 8px; border-radius: 0 0 10px 10px; }
    .btn-add { flex: 1; background: white; border: 1.5px solid #003366; color: #003366; border-radius: 5px; padding: 7px 0; font-weight: 700; cursor: pointer; font-size: 12px; }
    .btn-book { flex: 1; background: #00a896; border: none; color: white; border-radius: 5px; padding: 7px 0; font-weight: 700; cursor: pointer; font-size: 12px; }

    .see-more-strip {
      margin-top: 16px; background: #002244; color: white; border-radius: 8px; padding: 12px 20px;
      display: flex; justify-content: space-between; align-items: center;
    }
    .see-more-btn { background: #00a896; color: white; text-decoration: none; font-weight: 700; font-size: 12px; padding: 7px 18px; border-radius: 16px; }

    footer { background: #001f3f; color: #94a3b8; padding: 16px 24px 10px; margin-top: auto; border-top: 2px solid #00a896; width: 100%; font-size: 11px; }
    .footer-container { max-width: 1280px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
  </style>
</head>
<body>

  <div class="topbar">
    <div>📞 Helpline: <b>+91 6353468394</b> | ✉️ Support: <b>rajmore2023@gmail.com</b></div>
    <div><i class="dot"></i> Gateway Mesh: <b>AUTHENTICATED (PORT 3000)</b></div>
  </div>

  <header>
    <div class="nav">
      <a href="/index.html" class="logo">CARE<span>GRID</span> <small style="font-size:10px; color:#64748b; font-weight:400;">| DIAGNOSTICS</small></a>
      <ul class="menu">
        <li><a href="/index.html" style="color:#00a896; font-weight:bold;">Home</a></li>
        <li><a href="/services.html">All 35 Services</a></li>
        <li><a href="/cart.html">Shopping Cart</a></li>
        <li><a href="/orders.html">My Bookings</a></li>
      </ul>
      <div class="actions">
        <a href="/orders.html" class="user-pill">
          👤 <span id="userNameNav">Raj More</span>
          <button class="btn-logout" onclick="logout(event)">Logout</button>
        </a>
        <a href="/cart.html" class="btn-cart">Cart <span class="badge" id="cartBadge">0</span></a>
      </div>
    </div>
  </header>

  <!-- 4 SLIDES AUTO-ROTATING EVERY 3 SECONDS -->
  <div class="carousel-wrapper">
    <div class="carousel-track" id="track">
      
      <!-- Slide 1: Doorstep Collection -->
      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">✓ NABL & ICMR ACCREDITED</span>
            <div class="slide-title">Accurate Diagnostics, <span>At Your Home.</span></div>
            <div class="slide-desc">Painless vacuum-sealed sample collection by certified phlebotomists with zero extra visit fee.</div>
            <a href="/services.html" class="btn-slide-cta">Explore 35 Packages &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">🩺</div>
            <div class="slide-meta">
              <h4>Free Home Pickup</h4>
              <p>Phlebotomist arrives within 60 mins</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 2: Express 6-Hour Turnaround -->
      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">⚡ 6-HOUR TURNAROUND</span>
            <div class="slide-title">Express Delivery <span>Digital Reports.</span></div>
            <div class="slide-desc">Cold-chain specimen transport with automated barcode tracking and instant PDF alerts.</div>
            <a href="/orders.html" class="btn-slide-cta">Track Live Samples &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">📑</div>
            <div class="slide-meta">
              <h4>Doctor-Verified Reports</h4>
              <p>Smart NABL-certified PDF reports</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 3: Cash on Doorstep Collection -->
      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">💵 ZERO ADVANCE PAYMENT</span>
            <div class="slide-title">Cash On Collection, <span>Complete Trust.</span></div>
            <div class="slide-desc">Zero advance card payment. Pay cash or UPI scan directly to collector after blood draw.</div>
            <a href="/services.html" class="btn-slide-cta">Schedule Sample &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">💵</div>
            <div class="slide-meta">
              <h4>Doorstep Payment</h4>
              <p>Pay phlebotomist after sample drawn</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 4: Full Body & Preventive Screening -->
      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">🛡️ PREVENTIVE HEALTHCARE</span>
            <div class="slide-title">Full Body Health <span>Preventive Checkup.</span></div>
            <div class="slide-desc">Cover vital markers: Heart, Liver, Kidney, Thyroid, Sugar, Vitamin D & B12 in one profile.</div>
            <a href="/services.html" class="btn-slide-cta">View Full Panels &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">🧪</div>
            <div class="slide-meta">
              <h4>Comprehensive Panels</h4>
              <p>Over 80+ essential biomarkers</p>
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- Indicator Dots -->
    <div class="carousel-indicators">
      <div class="c-dot active" onclick="setSlide(0)"></div>
      <div class="c-dot" onclick="setSlide(1)"></div>
      <div class="c-dot" onclick="setSlide(2)"></div>
      <div class="c-dot" onclick="setSlide(3)"></div>
    </div>
  </div>

  <!-- EXACTLY 3 POPULAR SERVICES (ONE-ROW FIT ON LAPTOP) -->
  <div class="main">
    <div class="section-header">
      <div class="section-title">Popular Diagnostic Packages</div>
      <div class="badge-pop">Top 3 Most Booked</div>
    </div>

    <div class="grid-3" id="homeGrid"></div>

    <div class="see-more-strip">
      <div>
        <b>Need Full Body or Specialized Panels?</b>
        <span style="color:#94a3b8; margin-left:6px;">Browse complete 35 test catalog (Heart, Liver, Kidney, Vitamins).</span>
      </div>
      <a href="/services.html" class="see-more-btn">View All 35 Services &rarr;</a>
    </div>
  </div>

  <footer>
    <div class="footer-container">
      <div>© 2026 CareGrid Healthcare Technologies Pvt Ltd. | Helpline: +91 6353468394 | rajmore2023@gmail.com</div>
      <div>SG Highway, Ahmedabad, Gujarat - 380054</div>
    </div>
  </footer>

  <script>
    // 1. CAROUSEL AUTO-ROTATE EVERY 3 SECONDS (3000ms)
    let currentSlide = 0;
    const totalSlides = 4;
    const track = document.getElementById('track');
    const dots = document.querySelectorAll('.c-dot');

    function updateCarousel() {
      track.style.transform = `translateX(-${currentSlide * 25}%)`;
      dots.forEach((d, idx) => d.classList.toggle('active', idx === currentSlide));
    }

    function setSlide(idx) {
      currentSlide = idx;
      updateCarousel();
    }

    setInterval(() => {
      currentSlide = (currentSlide + 1) % totalSlides;
      updateCarousel();
    }, 3000); // exactly 3 seconds

    // 2. USER & CART STATE
    document.getElementById('userNameNav').innerText = localStorage.getItem('caregrid_user_name') || 'Raj More';
    let cart = JSON.parse(localStorage.getItem('caregrid_cart') || '[]');
    document.getElementById('cartBadge').innerText = cart.length;

    // 3. FETCH EXACT TOP 3 BOOKING PACKAGES FOR HOMEPAGE
    fetch('/api/catalog/products')
      .then(res => res.json())
      .then(data => {
        const grid = document.getElementById('homeGrid');
        grid.innerHTML = '';
        const top3 = data.tests.slice(0, 3);
        top3.forEach(test => {
          grid.innerHTML += `
            <div class="card">
              <div class="card-body">
                <span class="tag">${test.category}</span>
                <div class="title">${test.name}</div>
                <div class="desc">🩺 ${test.parameters}</div>
                <div class="price">${test.price}</div>
              </div>
              <div class="card-footer">
                <button class="btn-add" onclick="addToCart('${test.name}', ${test.numPrice})">Add to Cart</button>
                <button class="btn-book" onclick="bookNow('${test.name}', ${test.numPrice})">Instant Book</button>
              </div>
            </div>
          `;
        });
      });

    function addToCart(name, price) {
      cart.push({ name, price });
      localStorage.setItem('caregrid_cart', JSON.stringify(cart));
      document.getElementById('cartBadge').innerText = cart.length;
      alert(`✔ Added to Cart: ${name}\nRedirecting to Cart Service...`);
      window.location.href = '/cart.html';
    }

    function bookNow(name, price) {
      cart = [{ name, price }];
      localStorage.setItem('caregrid_cart', JSON.stringify(cart));
      window.location.href = '/checkout.html';
    }

    function logout(e) {
      e.preventDefault();
      localStorage.removeItem('caregrid_auth');
      window.location.href = '/login.html';
    }
  </script>
</body>
</html>
EOF

# Copy file directly into running container
docker cp index.html $(docker compose ps -q frontend):/usr/share/nginx/html/index.html
cd ..
clear
cd ~
# ==========================================
# 1. BOOKING SERVICE (Port 5004) - Real Storage
# ==========================================
cat << 'EOF' > booking-service/server.js
const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors());
app.use(express.json());

let databaseBookings = [];

app.get('/health', (req, res) => res.json({ status: 'UP', service: 'booking-service' }));

app.post('/book', (req, res) => {
  const { patient, phone, address, tests, amount } = req.body;
  const newBooking = {
    id: 'CG-' + Math.floor(100000 + Math.random() * 900000),
    patient: patient || 'Raj More',
    phone: phone || '6353468394',
    address: address || 'Ahmedabad, Gujarat',
    tests: tests || 'Comprehensive Health Profile',
    amount: amount || '₹799',
    date: new Date().toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' }),
    status: 'Active',
    collector: 'Sunil Varma (+91 98250 12345)'
  };
  databaseBookings.unshift(newBooking);
  res.json({ success: true, message: 'Booking stored successfully', booking: newBooking });
});

app.get('/list', (req, res) => res.json({ total: databaseBookings.length, bookings: databaseBookings }));

app.post('/cancel', (req, res) => {
  const { id } = req.body;
  const b = databaseBookings.find(x => x.id === id);
  if (b) {
    b.status = 'Cancelled';
    b.cancelledDate = new Date().toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' });
    return res.json({ success: true, booking: b });
  }
  res.status(404).json({ success: false, message: 'Booking not found' });
});

app.listen(5004, () => console.log('Booking Service on 5004'));
EOF

# ==========================================
# 2. NOTIFICATION SERVICE (Port 5006) - Callbacks
# ==========================================
cat << 'EOF' > notification-service/server.js
const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors());
app.use(express.json());

let callbackRequests = [];

app.get('/health', (req, res) => res.json({ status: 'UP', service: 'notification-service' }));

app.post('/callback', (req, res) => {
  const { phone, query } = req.body;
  const entry = {
    id: 'REQ-' + Math.floor(1000 + Math.random() * 9000),
    phone: phone || '6353468394',
    query: query || 'General Diagnostic Consultation',
    time: new Date().toLocaleTimeString('en-IN'),
    status: 'Queued for Team Contact'
  };
  callbackRequests.unshift(entry);
  res.json({ success: true, message: 'Team will connect you shortly', request: entry });
});

app.get('/callbacks', (req, res) => res.json({ total: callbackRequests.length, requests: callbackRequests }));

app.listen(5006, () => console.log('Notification on 5006'));
EOF

# ==========================================
# 3. NGINX ROUTING (frontend/nginx.conf)
# ==========================================
cat << 'EOF' > frontend/nginx.conf
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html login.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/auth/ { proxy_pass http://auth-service:5001/; }
    location /api/catalog/ { proxy_pass http://catalog-service:5003/; }
    location /api/cart/ { proxy_pass http://cart-service:5002/; }
    location /api/booking/ { proxy_pass http://booking-service:5004/; }
    location /api/payment/ { proxy_pass http://payment-service:5005/; }
    location /api/notification/ { proxy_pass http://notification-service:5006/; }
}
EOF

# ==========================================
# 4. HOMEPAGE (frontend/index.html)
# ==========================================
cat << 'EOF' > frontend/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>CareGrid Diagnostics | Trusted Pathology Lab & Diagnostics</title>
  <script>
    if (localStorage.getItem('caregrid_auth') !== 'true') {
      window.location.replace('/login.html');
    }
  </script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif; }
    body { background: #f8fafc; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; font-size: 13.5px; }

    /* Top Utility Bar */
    .topbar { background: #00172e; color: #94a3b8; font-size: 12px; padding: 6px 30px; display: flex; justify-content: space-between; align-items: center; }
    .topbar b { color: #f1f5f9; }
    .btn-callback-top { background: #00a896; color: white; border: none; padding: 3px 12px; border-radius: 14px; font-weight: 700; cursor: pointer; font-size: 11.5px; transition: 0.2s; }
    .btn-callback-top:hover { background: #008f80; }

    /* Header Nav */
    header { background: #ffffff; box-shadow: 0 2px 8px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100; }
    .nav { max-width: 1280px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; padding: 10px 24px; gap: 15px; }
    .logo { font-size: 21px; font-weight: 800; color: #003366; text-decoration: none; display: flex; align-items: center; gap: 4px; }
    .logo span { color: #00a896; }
    
    /* Live Search Box on Home */
    .search-wrap { position: relative; flex: 1; max-width: 380px; }
    .search-inp { width: 100%; padding: 8px 16px; border: 1.5px solid #cbd5e1; border-radius: 20px; font-size: 12.5px; outline: none; transition: 0.2s; }
    .search-inp:focus { border-color: #00a896; box-shadow: 0 0 0 3px rgba(0,168,150,0.15); }

    .menu { display: flex; list-style: none; gap: 18px; font-weight: 600; font-size: 13.5px; align-items: center; }
    .menu a { color: #334155; text-decoration: none; }
    .menu a:hover { color: #00a896; }

    .actions { display: flex; gap: 10px; align-items: center; }
    .user-pill { background: #e6fffa; color: #003366; border: 1px solid #00a896; padding: 5px 12px; border-radius: 20px; font-weight: 700; font-size: 12px; text-decoration: none; display: flex; align-items: center; gap: 5px; }
    .btn-logout { background: none; border: none; color: #ef4444; font-size: 11px; font-weight: bold; cursor: pointer; text-decoration: underline; margin-left: 4px; }
    .btn-cart { background: #003366; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 700; text-decoration: none; font-size: 12.5px; display: flex; gap: 6px; align-items: center; }
    .badge { background: #00a896; border-radius: 50%; padding: 2px 6px; font-size: 11px; }

    /* 3-Second Medium Hero Carousel */
    .carousel-wrapper { position: relative; background: linear-gradient(135deg, #001f3f 0%, #003366 50%, #004d61 100%); color: white; overflow: hidden; height: 195px; }
    .carousel-track { display: flex; transition: transform 0.5s cubic-bezier(0.25, 1, 0.5, 1); width: 400%; height: 100%; }
    .carousel-slide { width: 25%; height: 100%; padding: 16px 30px; display: flex; align-items: center; justify-content: center; }
    .slide-inner { max-width: 1200px; width: 100%; display: flex; justify-content: space-between; align-items: center; gap: 24px; }
    .badge-pill { display: inline-block; background: rgba(255, 255, 255, 0.12); border: 1px solid rgba(0, 168, 150, 0.6); padding: 2px 10px; border-radius: 20px; font-size: 10.5px; font-weight: 700; color: #5eead4; margin-bottom: 5px; }
    .slide-title { font-size: 21px; font-weight: 800; line-height: 1.2; margin-bottom: 4px; }
    .slide-title span { color: #38bdf8; }
    .slide-desc { font-size: 12.5px; color: #cbd5e1; margin-bottom: 10px; max-width: 520px; line-height: 1.35; }
    .btn-slide-cta { background: #00a896; color: white; text-decoration: none; font-weight: 700; font-size: 12px; padding: 6px 16px; border-radius: 16px; display: inline-block; }

    .slide-right-card { background: rgba(15, 23, 42, 0.55); border: 1px solid rgba(255, 255, 255, 0.15); backdrop-filter: blur(8px); padding: 10px 16px; border-radius: 10px; display: flex; align-items: center; gap: 12px; min-width: 270px; }
    .slide-icon { width: 36px; height: 36px; border-radius: 8px; background: rgba(0, 168, 150, 0.25); display: flex; align-items: center; justify-content: center; font-size: 18px; flex-shrink: 0; }
    .slide-meta h4 { font-size: 13px; font-weight: 700; color: #fff; margin-bottom: 2px; }
    .slide-meta p { font-size: 11px; color: #94a3b8; }

    .carousel-indicators { position: absolute; bottom: 6px; left: 50%; transform: translateX(-50%); display: flex; gap: 6px; }
    .c-dot { width: 7px; height: 7px; border-radius: 50%; background: rgba(255,255,255,0.3); transition: 0.3s; cursor: pointer; }
    .c-dot.active { width: 18px; border-radius: 8px; background: #00a896; }

    /* Top 3 Featured Section */
    .main { max-width: 1280px; width: 100%; margin: 16px auto 25px; padding: 0 24px; flex: 1; }
    .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
    .section-title { font-size: 18px; font-weight: 800; color: #003366; }
    .badge-pop { background: #e6fffa; color: #00a896; font-size: 11px; font-weight: 800; padding: 3px 9px; border-radius: 16px; border: 1px solid #99f6e4; }

    .grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; }
    @media (max-width: 850px) { .grid-3 { grid-template-columns: 1fr; } }

    .card { background: white; border-radius: 10px; border: 1px solid #e2e8f0; box-shadow: 0 2px 5px rgba(0,0,0,0.03); display: flex; flex-direction: column; justify-content: space-between; transition: 0.2s; }
    .card:hover { transform: translateY(-2px); box-shadow: 0 6px 14px rgba(0,0,0,0.06); border-color: #00a896; }
    .card-body { padding: 15px; }
    .tag { background: #e6fffa; color: #00a896; font-size: 10px; font-weight: 800; text-transform: uppercase; padding: 2px 7px; border-radius: 3px; display: inline-block; margin-bottom: 6px; }
    .title { font-size: 15px; font-weight: 700; color: #003366; margin-bottom: 4px; }
    .desc { font-size: 11.5px; color: #64748b; margin-bottom: 8px; line-height: 1.35; min-height: 30px; }
    .price { font-size: 20px; font-weight: 800; color: #003366; border-top: 1px solid #f1f5f9; padding-top: 8px; }
    .card-footer { padding: 10px 15px; background: #f8fafc; border-top: 1px solid #f1f5f9; display: flex; gap: 8px; border-radius: 0 0 10px 10px; }
    .btn-add { flex: 1; background: white; border: 1.5px solid #003366; color: #003366; border-radius: 5px; padding: 7px 0; font-weight: 700; cursor: pointer; font-size: 12px; }
    .btn-book { flex: 1; background: #00a896; border: none; color: white; border-radius: 5px; padding: 7px 0; font-weight: 700; cursor: pointer; font-size: 12px; }

    /* Static Educational Content Section */
    .edu-section { margin-top: 30px; background: #ffffff; border-radius: 12px; border: 1px solid #e2e8f0; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
    .edu-title { font-size: 17px; font-weight: 800; color: #003366; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
    .edu-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
    @media (max-width: 850px) { .edu-grid { grid-template-columns: 1fr; } }
    .edu-box { background: #f8fafc; padding: 14px 16px; border-radius: 8px; border-left: 3px solid #00a896; }
    .edu-box h4 { color: #003366; font-size: 13.5px; margin-bottom: 4px; font-weight: 700; }
    .edu-box p { color: #64748b; font-size: 12px; line-height: 1.45; }

    /* Callback Modal */
    .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); backdrop-filter: blur(2px); z-index: 1000; align-items: center; justify-content: center; }
    .modal-card { background: white; border-radius: 12px; width: 90%; max-width: 400px; padding: 26px; box-shadow: 0 20px 25px rgba(0,0,0,0.25); }
    .btn-submit-cb { width: 100%; background: #00a896; color: white; border: none; padding: 12px; border-radius: 6px; font-weight: 700; cursor: pointer; margin-top: 10px; }

    /* Footer */
    footer { background: #001f3f; color: #94a3b8; padding: 35px 24px 15px; margin-top: auto; border-top: 3px solid #00a896; width: 100%; font-size: 12px; }
    .footer-container { max-width: 1280px; margin: 0 auto; display: grid; grid-template-columns: 1.8fr 1fr 1fr 1.6fr; gap: 30px; }
    .footer-col h4 { color: #fff; font-size: 14px; margin-bottom: 12px; }
    .footer-col ul { list-style: none; }
    .footer-col ul li { margin-bottom: 8px; }
    .footer-col ul li a { color: #cbd5e1; text-decoration: none; }
    .footer-col ul li a:hover { color: #00a896; }
    .footer-bottom { max-width: 1280px; margin: 25px auto 0; padding-top: 15px; border-top: 1px solid #1e3a5f; display: flex; justify-content: space-between; }
  </style>
</head>
<body>

  <div class="topbar">
    <div>📞 Helpline: <b>+91 6353468394</b> | ✉️ Support: <b>rajmore2023@gmail.com</b></div>
    <div>
      <button class="btn-callback-top" onclick="openCallback()">📞 Request Call Back</button>
      <span style="margin-left: 10px; color:#10b981;">● All 6 Microservices Synchronized</span>
    </div>
  </div>

  <header>
    <div class="nav">
      <a href="/index.html" class="logo">CARE<span>GRID</span> <small style="font-size:10px; color:#64748b; font-weight:400;">| DIAGNOSTICS</small></a>
      
      <!-- Live Search Bar -->
      <div class="search-wrap">
        <input type="text" class="search-inp" id="homeSearch" placeholder="🔍 Search 35+ tests (CBC, Lipid, Thyroid, Sugar)..." onkeyup="handleSearch(event)">
      </div>

      <ul class="menu">
        <li><a href="/index.html" style="color:#00a896; font-weight:bold;">Home</a></li>
        <li><a href="/services.html">All 35 Services</a></li>
        <li><a href="/cart.html">Shopping Cart</a></li>
        <li><a href="/orders.html">My Bookings</a></li>
      </ul>
      <div class="actions">
        <a href="/orders.html" class="user-pill">
          👤 <span id="userNameNav">Raj More</span>
          <button class="btn-logout" onclick="logout(event)">Logout</button>
        </a>
        <a href="/cart.html" class="btn-cart">Cart <span class="badge" id="cartBadge">0</span></a>
      </div>
    </div>
  </header>

  <!-- 3-Second 4-Slide Hero Carousel -->
  <div class="carousel-wrapper">
    <div class="carousel-track" id="track">
      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">✓ NABL & ICMR ACCREDITED</span>
            <div class="slide-title">Accurate Diagnostics, <span>At Your Home.</span></div>
            <div class="slide-desc">Painless vacuum-sealed sample collection by certified phlebotomists with zero extra visit fee.</div>
            <a href="/services.html" class="btn-slide-cta">Explore 35 Packages &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">🩺</div>
            <div class="slide-meta"><h4>Free Home Pickup</h4><p>Phlebotomist arrives within 60 mins</p></div>
          </div>
        </div>
      </div>

      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">⚡ 6-HOUR TURNAROUND</span>
            <div class="slide-title">Express Delivery <span>Digital Reports.</span></div>
            <div class="slide-desc">Cold-chain specimen transport with automated barcode tracking and instant PDF alerts.</div>
            <a href="/orders.html" class="btn-slide-cta">Track Live Samples &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">📑</div>
            <div class="slide-meta"><h4>Doctor-Verified Reports</h4><p>Smart NABL-certified PDF reports</p></div>
          </div>
        </div>
      </div>

      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">💵 ZERO ADVANCE PAYMENT</span>
            <div class="slide-title">Cash On Collection, <span>Complete Trust.</span></div>
            <div class="slide-desc">Zero advance card payment. Pay cash or UPI scan directly to collector after blood draw.</div>
            <a href="/services.html" class="btn-slide-cta">Schedule Sample &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">💵</div>
            <div class="slide-meta"><h4>Doorstep Payment</h4><p>Pay phlebotomist after sample drawn</p></div>
          </div>
        </div>
      </div>

      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">🛡️ PREVENTIVE HEALTHCARE</span>
            <div class="slide-title">Full Body Health <span>Preventive Checkup.</span></div>
            <div class="slide-desc">Cover vital markers: Heart, Liver, Kidney, Thyroid, Sugar, Vitamin D & B12 in one profile.</div>
            <a href="/services.html" class="btn-slide-cta">View Full Panels &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">🧪</div>
            <div class="slide-meta"><h4>Comprehensive Panels</h4><p>Over 80+ essential biomarkers</p></div>
          </div>
        </div>
      </div>
    </div>

    <div class="carousel-indicators">
      <div class="c-dot active" onclick="setSlide(0)"></div>
      <div class="c-dot" onclick="setSlide(1)"></div>
      <div class="c-dot" onclick="setSlide(2)"></div>
      <div class="c-dot" onclick="setSlide(3)"></div>
    </div>
  </div>

  <!-- Top 3 Featured Diagnostic Services -->
  <div class="main">
    <div class="section-header">
      <div class="section-title">Popular Diagnostic Packages</div>
      <div class="badge-pop">Top 3 Most Booked</div>
    </div>

    <div class="grid-3" id="homeGrid"></div>

    <div style="margin-top: 16px; background: #002244; color: white; border-radius: 8px; padding: 12px 20px; display: flex; justify-content: space-between; align-items: center;">
      <div>
        <b>Need Full Body or Specialized Panels?</b>
        <span style="color:#94a3b8; margin-left:6px;">Browse complete 35 test catalog (Heart, Liver, Kidney, Vitamins).</span>
      </div>
      <a href="/services.html" style="background:#00a896; color:white; text-decoration:none; font-weight:700; font-size:12px; padding:7px 18px; border-radius:16px;">View All 35 Services &rarr;</a>
    </div>

    <!-- Informative Static Reading Section -->
    <div class="edu-section">
      <div class="edu-title">📖 Clinical Laboratory Standards & Patient Care Guidelines</div>
      <div class="edu-grid">
        <div class="edu-box">
          <h4>Temperature-Controlled Cold Chain</h4>
          <p>Blood samples are preserved in vacuum-sealed EDTA/Gel tubes at 2°C–8°C ice-pack coolers to prevent hemolysis and guarantee 99.8% precision.</p>
        </div>
        <div class="edu-box">
          <h4>Barcoded Sample Tracking</h4>
          <p>Each phlebotomist visit assigns unique dual-barcoded labels verified against patient ID to ensure zero mix-ups in high-throughput automation.</p>
        </div>
        <div class="edu-box">
          <h4>NABL & ICMR Clinical Sign-Off</h4>
          <p>Every diagnostic profile is independently reviewed by our Senior Clinical Pathologists and Biochemists before releasing digitally signed PDF reports.</p>
        </div>
      </div>
    </div>
  </div>

  <!-- Request Call Back Modal -->
  <div class="modal-overlay" id="callbackModal">
    <div class="modal-card">
      <h3 style="color:#003366; font-size:17px; margin-bottom:6px;">Request an Immediate Call Back</h3>
      <p style="color:#64748b; font-size:12px; margin-bottom:14px;">Enter your phone number and our diagnostic specialist will contact you.</p>
      
      <div style="margin-bottom:12px;">
        <label style="font-size:11.5px; font-weight:700; color:#475569;">Your Contact Number</label>
        <input type="text" id="cbPhone" value="6353468394" style="width:100%; padding:9px 12px; border:1.5px solid #cbd5e1; border-radius:6px; font-size:14px; margin-top:4px;">
      </div>

      <div style="margin-bottom:14px;">
        <label style="font-size:11.5px; font-weight:700; color:#475569;">Test Inquiry / Query</label>
        <input type="text" id="cbQuery" value="Need assistance booking Full Body Health Checkup" style="width:100%; padding:9px 12px; border:1.5px solid #cbd5e1; border-radius:6px; font-size:13px; margin-top:4px;">
      </div>

      <button class="btn-submit-cb" onclick="submitCallback()">Submit Call Back Request</button>
      <button onclick="document.getElementById('callbackModal').style.display='none'" style="width:100%; background:none; border:none; color:#64748b; font-size:12px; margin-top:8px; cursor:pointer;">Cancel</button>
    </div>
  </div>

  <footer>
    <div class="footer-container">
      <div class="footer-col">
        <h3 style="color:#fff; font-size:18px; margin-bottom:8px;">CARE<span style="color:#00a896;">GRID</span></h3>
        <p style="line-height:1.6; color:#94a3b8;">Accredited diagnostic pathology network delivering high-accuracy laboratory panels and certified phlebotomy doorstep visits.</p>
      </div>
      <div class="footer-col">
        <h4>Catalog</h4>
        <ul>
          <li><a href="/services.html">All 35 Diagnostic Packages</a></li>
          <li><a href="/services.html">Heart & Cardiac Biomarkers</a></li>
          <li><a href="/services.html">Diabetes Management Profiles</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Patient Services</h4>
        <ul>
          <li><a href="/cart.html">Shopping Cart</a></li>
          <li><a href="/orders.html">My Scheduled Bookings</a></li>
          <li><a href="/orders.html">Cancelled Bookings Record</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Central Helpdesk</h4>
        <p style="color:#cbd5e1; line-height:1.8;">
          📞 <b>Helpline:</b> +91 6353468394<br>
          ✉️ <b>Support:</b> rajmore2023@gmail.com<br>
          📍 <b>Central Lab:</b> SG Highway, Ahmedabad, Gujarat - 380054
        </p>
      </div>
    </div>
    <div class="footer-bottom">
      <div>© 2026 CareGrid Healthcare Technologies Pvt Ltd. All rights reserved.</div>
      <div>Helpline: +91 6353468394 | rajmore2023@gmail.com</div>
    </div>
  </footer>

  <script>
    // Carousel Rotation (3 seconds)
    let currentSlide = 0;
    const track = document.getElementById('track');
    const dots = document.querySelectorAll('.c-dot');
    function updateCarousel() {
      track.style.transform = `translateX(-${currentSlide * 25}%)`;
      dots.forEach((d, idx) => d.classList.toggle('active', idx === currentSlide));
    }
    function setSlide(idx) { currentSlide = idx; updateCarousel(); }
    setInterval(() => { currentSlide = (currentSlide + 1) % 4; updateCarousel(); }, 3000);

    // User & Cart State
    document.getElementById('userNameNav').innerText = localStorage.getItem('caregrid_user_name') || 'Raj More';
    let cart = JSON.parse(localStorage.getItem('caregrid_cart') || '[]');
    document.getElementById('cartBadge').innerText = cart.length;

    // Fetch strictly Top 3 for Homepage
    fetch('/api/catalog/products')
      .then(res => res.json())
      .then(data => {
        const grid = document.getElementById('homeGrid');
        grid.innerHTML = '';
        const top3 = data.tests.slice(0, 3);
        top3.forEach(test => {
          grid.innerHTML += `
            <div class="card">
              <div class="card-body">
                <span class="tag">${test.category}</span>
                <div class="title">${test.name}</div>
                <div class="desc">🩺 ${test.parameters}</div>
                <div class="price">${test.price}</div>
              </div>
              <div class="card-footer">
                <button class="btn-add" onclick="addToCart('${test.name}', ${test.numPrice})">Add to Cart</button>
                <button class="btn-book" onclick="bookNow('${test.name}', ${test.numPrice})">Instant Book</button>
              </div>
            </div>
          `;
        });
      });

    function addToCart(name, price) {
      cart.push({ name, price });
      localStorage.setItem('caregrid_cart', JSON.stringify(cart));
      document.getElementById('cartBadge').innerText = cart.length;
      alert(`✔ ${name} has been added to your cart!\nRedirecting to Shopping Cart...`);
      window.location.href = '/cart.html';
    }

    function bookNow(name, price) {
      cart = [{ name, price }];
      localStorage.setItem('caregrid_cart', JSON.stringify(cart));
      window.location.href = '/checkout.html';
    }

    function handleSearch(e) {
      if (e.key === 'Enter') {
        const val = document.getElementById('homeSearch').value.trim();
        window.location.href = '/services.html?search=' + encodeURIComponent(val);
      }
    }

    function openCallback() {
      document.getElementById('callbackModal').style.display = 'flex';
    }

    function submitCallback() {
      const phone = document.getElementById('cbPhone').value.trim();
      const query = document.getElementById('cbQuery').value.trim();
      
      fetch('/api/notification/callback', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ phone, query })
      })
      .then(r => r.json())
      .then(res => {
        document.getElementById('callbackModal').style.display = 'none';
        alert(`✅ CALL BACK REQUEST REGISTERED!\nRef: ${res.request.id}\nPhone: ${phone}\nOur pathology coordinator will connect with you within 15 minutes.`);
      })
      .catch(() => {
        document.getElementById('callbackModal').style.display = 'none';
        alert(`✅ CALL BACK REQUEST REGISTERED!\nPhone: ${phone}\nOur team will connect with you shortly.`);
      });
    }

    function logout(e) {
      e.preventDefault();
      localStorage.removeItem('caregrid_auth');
      window.location.href = '/login.html';
    }
  </script>
</body>
</html>
EOF

# ==========================================
# 5. CART PAGE (frontend/cart.html)
# ==========================================
cat << 'EOF' > frontend/cart.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>CareGrid Diagnostics | Shopping Cart Service</title>
  <script>
    if (localStorage.getItem('caregrid_auth') !== 'true') window.location.replace('/login.html');
  </script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Roboto, sans-serif; }
    body { background: #f8fafc; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; font-size: 13.5px; }
    header { background: #fff; padding: 12px 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
    .logo { font-size: 20px; font-weight: 800; color: #003366; text-decoration: none; }
    .logo span { color: #00a896; }
    .container { max-width: 950px; width: 100%; margin: 30px auto 50px; padding: 0 20px; flex: 1; }
    .cart-grid { display: grid; grid-template-columns: 1.8fr 1.2fr; gap: 24px; }
    @media (max-width: 768px) { .cart-grid { grid-template-columns: 1fr; } }
    .card { background: white; border-radius: 10px; border: 1px solid #e2e8f0; padding: 20px; box-shadow: 0 2px 6px rgba(0,0,0,0.03); }
    .item-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f1f5f9; }
    .btn-del { color: #ef4444; background: none; border: none; cursor: pointer; font-size: 12px; font-weight: bold; }
    .btn-checkout { width: 100%; background: #00a896; color: white; border: none; padding: 12px; border-radius: 6px; font-weight: 700; font-size: 14px; cursor: pointer; margin-top: 15px; text-align: center; display: block; text-decoration: none; }
  </style>
</head>
<body>
  <header>
    <a href="/index.html" class="logo">CARE<span>GRID</span> <small style="font-size:11px; color:#64748b;">| CART SERVICE</small></a>
    <div style="display:flex; gap:16px; align-items:center;">
      <a href="/services.html" style="color:#00a896; text-decoration:none; font-weight:700;">+ Browse 35 Tests</a>
      <a href="/orders.html" style="color:#003366; text-decoration:none; font-weight:700;">My Bookings</a>
    </div>
  </header>

  <div class="container">
    <h2 style="color:#003366; font-size:20px; margin-bottom:16px;">Diagnostic Cart Review</h2>
    <div class="cart-grid">
      <div class="card">
        <h3 style="font-size:15px; margin-bottom:12px; color:#003366;">Selected Health Packages</h3>
        <div id="cartItemsList"></div>
      </div>
      
      <div class="card" style="height: fit-content;">
        <h3 style="font-size:15px; margin-bottom:12px; color:#003366;">Price Breakdown</h3>
        <div style="display:flex; justify-content:space-between; margin-bottom:10px; color:#64748b;">
          <span>Home Blood Pickup Fee:</span><span style="color:#16a34a; font-weight:700;">FREE (₹0)</span>
        </div>
        <div style="display:flex; justify-content:space-between; margin-bottom:16px; font-size:17px; font-weight:800; color:#003366; border-top:1px solid #f1f5f9; padding-top:10px;">
          <span>Total Payable:</span><span id="cartGrandTotal">₹0</span>
        </div>
        <a href="/checkout.html" id="checkoutBtn" class="btn-checkout">Proceed to Schedule Doorstep Visit &rarr;</a>
      </div>
    </div>
  </div>

  <script>
    let cart = JSON.parse(localStorage.getItem('caregrid_cart') || '[]');

    function renderCart() {
      const list = document.getElementById('cartItemsList');
      if (cart.length === 0) {
        list.innerHTML = '<p style="color:#64748b; padding:25px 0; text-align:center;">Your cart is empty.<br><a href="/services.html" style="color:#00a896; font-weight:bold; margin-top:8px; display:inline-block;">Explore 35 Diagnostic Packages</a></p>';
        document.getElementById('cartGrandTotal').innerText = '₹0';
        document.getElementById('checkoutBtn').style.display = 'none';
        return;
      }
      let html = '';
      let sum = 0;
      cart.forEach((item, index) => {
        sum += item.price;
        html += `
          <div class="item-row">
            <div>
              <b style="color:#003366; font-size:14px;">${item.name}</b>
              <div style="color:#00a896; font-weight:700; margin-top:2px;">₹${item.price}</div>
            </div>
            <button class="btn-del" onclick="removeItem(${index})">Remove</button>
          </div>
        `;
      });
      list.innerHTML = html;
      document.getElementById('cartGrandTotal').innerText = '₹' + sum;
      document.getElementById('checkoutBtn').style.display = 'block';
    }

    function removeItem(index) {
      cart.splice(index, 1);
      localStorage.setItem('caregrid_cart', JSON.stringify(cart));
      renderCart();
    }
    renderCart();
  </script>
</body>
</html>
EOF

# ==========================================
# 6. CHECKOUT & BOOKING (frontend/checkout.html)
# ==========================================
cat << 'EOF' > frontend/checkout.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>CareGrid Diagnostics | Doorstep Booking Service</title>
  <script>
    if (localStorage.getItem('caregrid_auth') !== 'true') window.location.replace('/login.html');
  </script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Roboto, sans-serif; }
    body { background: #f8fafc; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; font-size: 13.5px; }
    header { background: #fff; padding: 12px 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
    .logo { font-size: 20px; font-weight: 800; color: #003366; text-decoration: none; }
    .logo span { color: #00a896; }
    .container { max-width: 600px; width: 100%; margin: 30px auto 50px; padding: 0 20px; flex: 1; }
    .card { background: white; border-radius: 12px; border: 1px solid #e2e8f0; padding: 26px; box-shadow: 0 4px 12px rgba(0,0,0,0.04); }
    .form-group { margin-bottom: 14px; }
    .form-group label { display: block; font-size: 12px; font-weight: 700; color: #475569; margin-bottom: 4px; }
    .form-group input { width: 100%; padding: 10px 12px; border: 1.5px solid #cbd5e1; border-radius: 6px; font-size: 14px; outline: none; }
    .pay-card { background: #f0fdfa; border: 1px solid #00a896; padding: 12px; border-radius: 6px; font-size: 13px; font-weight: 600; color: #003366; margin: 16px 0; }
    .btn-confirm { width: 100%; background: #003366; color: white; border: none; padding: 13px; border-radius: 6px; font-weight: 700; font-size: 14.5px; cursor: pointer; }
    .btn-confirm:hover { background: #002244; }
  </style>
</head>
<body>
  <header>
    <a href="/index.html" class="logo">CARE<span>GRID</span> <small style="font-size:11px; color:#64748b;">| BOOKING SERVICE</small></a>
    <a href="/cart.html" style="color:#00a896; text-decoration:none; font-weight:700;">&larr; Return to Cart</a>
  </header>

  <div class="container">
    <div class="card">
      <h2 style="color:#003366; font-size:19px; margin-bottom:4px;">Doorstep Sample Collection Schedule</h2>
      <p style="color:#64748b; font-size:12.5px; margin-bottom:18px;">Certified phlebotomist will arrive with sterile vacuum kits.</p>

      <div class="form-group">
        <label>Patient Full Name</label>
        <input type="text" id="custName" value="Raj More">
      </div>
      <div class="form-group">
        <label>Registered Mobile Number</label>
        <input type="text" id="custPhone" value="+91 6353468394">
      </div>
      <div class="form-group">
        <label>Doorstep Sample Pickup Address</label>
        <input type="text" id="custAddr" value="Plot 42, Satellite Area, Ahmedabad, Gujarat - 380054">
      </div>

      <div class="pay-card">
        💵 Payment Term: <b>Cash on Collection</b> (Pay phlebotomist directly at doorstep)
      </div>

      <button class="btn-confirm" onclick="confirmAndStoreBooking()">Schedule Phlebotomist &rarr;</button>
    </div>
  </div>

  <script>
    function confirmAndStoreBooking() {
      const cart = JSON.parse(localStorage.getItem('caregrid_cart') || '[]');
      if (cart.length === 0) {
        alert('Your cart is empty!');
        window.location.href = '/services.html';
        return;
      }
      const sum = cart.reduce((acc, i) => acc + i.price, 0);
      const testNames = cart.map(t => t.name).join(', ');

      const payload = {
        patient: document.getElementById('custName').value,
        phone: document.getElementById('custPhone').value,
        address: document.getElementById('custAddr').value,
        tests: testNames,
        amount: '₹' + sum
      };

      // Call Booking Microservice to store in database
      fetch('/api/booking/book', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      })
      .then(res => res.json())
      .then(data => {
        // Also save to patient local orders
        const orders = JSON.parse(localStorage.getItem('caregrid_orders') || '[]');
        orders.unshift(data.booking);
        localStorage.setItem('caregrid_orders', JSON.stringify(orders));
        localStorage.removeItem('caregrid_cart');

        alert(`✅ BOOKING CONFIRMED & SAVED TO DATABASE!\nBooking Ref: ${data.booking.id}\nPatient: ${data.booking.patient}\nPhlebotomist assigned. Redirecting to My Bookings...`);
        window.location.href = '/orders.html';
      })
      .catch(() => {
        window.location.href = '/orders.html';
      });
    }
  </script>
</body>
</html>
EOF

# ==========================================
# 7. ORDERS & CANCELLATIONS (frontend/orders.html)
# ==========================================
cat << 'EOF' > frontend/orders.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>CareGrid Diagnostics | My Scheduled Bookings</title>
  <script>
    if (localStorage.getItem('caregrid_auth') !== 'true') window.location.replace('/login.html');
  </script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Roboto, sans-serif; }
    body { background: #f8fafc; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; font-size: 13.5px; }
    header { background: #fff; padding: 12px 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
    .logo { font-size: 20px; font-weight: 800; color: #003366; text-decoration: none; }
    .logo span { color: #00a896; }
    .container { max-width: 900px; width: 100%; margin: 25px auto 50px; padding: 0 20px; flex: 1; }
    .banner { background: #002244; color: white; border-radius: 10px; padding: 18px 24px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 22px; }
    .tab-bar { display: flex; gap: 18px; border-bottom: 2px solid #e2e8f0; margin-bottom: 20px; }
    .tab-btn { background: none; border: none; font-size: 14px; font-weight: 700; color: #64748b; padding: 8px 4px; cursor: pointer; position: relative; }
    .tab-btn.active { color: #00a896; }
    .tab-btn.active::after { content: ''; position: absolute; bottom: -2px; left: 0; width: 100%; height: 2px; background: #00a896; }
    .card { background: white; border: 1px solid #e2e8f0; border-radius: 10px; padding: 18px; margin-bottom: 14px; box-shadow: 0 2px 5px rgba(0,0,0,0.03); position: relative; }
    .badge-act { position: absolute; top: 16px; right: 16px; background: #ecfdf5; color: #059669; font-size: 11px; font-weight: 800; padding: 3px 8px; border-radius: 16px; border: 1px solid #a7f3d0; }
    .badge-can { position: absolute; top: 16px; right: 16px; background: #fef2f2; color: #dc2626; font-size: 11px; font-weight: 800; padding: 3px 8px; border-radius: 16px; border: 1px solid #fecaca; }
    .meta-box { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; background: #f8fafc; padding: 10px; border-radius: 6px; margin: 12px 0; font-size: 12.5px; color: #475569; }
    .btn-cancel { background: #fee2e2; border: 1px solid #fca5a5; color: #b91c1c; font-weight: 700; font-size: 12px; padding: 7px 14px; border-radius: 5px; cursor: pointer; }
  </style>
</head>
<body>
  <header>
    <a href="/index.html" class="logo">CARE<span>GRID</span> <small style="font-size:11px; color:#64748b;">| PATIENT ORDERS</small></a>
    <div style="display:flex; gap:16px; align-items:center;">
      <a href="/services.html" style="color:#00a896; text-decoration:none; font-weight:700;">+ Book New Test</a>
      <a href="/index.html" style="color:#003366; text-decoration:none; font-weight:700;">Home</a>
    </div>
  </header>

  <div class="container">
    <div class="banner">
      <div>
        <h3 id="uName">Raj More</h3>
        <p style="font-size:12px; color:#94a3b8;" id="uPhone">+91 6353468394 | Verified Primary Account</p>
      </div>
      <div style="background:rgba(255,255,255,0.12); padding:6px 14px; border-radius:6px; font-size:12px;">Active Patient Session</div>
    </div>

    <div class="tab-bar">
      <button class="tab-btn active" id="tabA" onclick="setTab('Active')">Active Scheduled Bookings (<span id="actCount">0</span>)</button>
      <button class="tab-btn" id="tabC" onclick="setTab('Cancelled')">Cancelled Bookings Record (<span id="canCount">0</span>)</button>
    </div>

    <div id="ordersList"></div>
  </div>

  <script>
    let curTab = 'Active';
    let orders = JSON.parse(localStorage.getItem('caregrid_orders') || '[]');

    window.onload = function() {
      document.getElementById('uName').innerText = localStorage.getItem('caregrid_user_name') || 'Raj More';
      document.getElementById('uPhone').innerText = "+91 " + (localStorage.getItem('caregrid_user_phone') || '6353468394') + " | Verified Primary Account";
      render();
    };

    function setTab(t) {
      curTab = t;
      document.getElementById('tabA').classList.toggle('active', t === 'Active');
      document.getElementById('tabC').classList.toggle('active', t === 'Cancelled');
      render();
    }

    function cancelOrder(id) {
      if (!confirm(`Are you sure you want to cancel booking ${id}?`)) return;

      fetch('/api/booking/cancel', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id })
      }).finally(() => {
        const o = orders.find(x => x.id === id);
        if (o) {
          o.status = 'Cancelled';
          o.cancelledDate = new Date().toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' });
          localStorage.setItem('caregrid_orders', JSON.stringify(orders));
          render();
        }
      });
    }

    function render() {
      const container = document.getElementById('ordersList');
      const act = orders.filter(x => x.status === 'Active');
      const can = orders.filter(x => x.status === 'Cancelled');

      document.getElementById('actCount').innerText = act.length;
      document.getElementById('canCount').innerText = can.length;

      const list = curTab === 'Active' ? act : can;
      if (list.length === 0) {
        container.innerHTML = `<p style="color:#64748b; text-align:center; padding:40px 0;">No ${curTab.toLowerCase()} bookings found.</p>`;
        return;
      }

      let html = '';
      list.forEach(o => {
        if (o.status === 'Active') {
          html += `
            <div class="card">
              <span class="badge-act">● Scheduled</span>
              <h3 style="color:#003366; font-size:15px;">Booking Ref: ${o.id}</h3>
              <p style="font-size:13.5px; font-weight:600; margin:5px 0;">🩺 ${o.tests}</p>
              <div class="meta-box">
                <div><b>Date:</b> ${o.date}</div>
                <div><b>Payable:</b> <span style="color:#00a896; font-weight:800;">${o.amount}</span></div>
                <div><b>Phlebotomist:</b> ${o.collector}</div>
                <div><b>Payment:</b> Cash on Doorstep Collection</div>
              </div>
              <button class="btn-cancel" onclick="cancelOrder('${o.id}')">Cancel This Booking</button>
            </div>
          `;
        } else {
          html += `
            <div class="card" style="border-color:#fecaca; background:#fffbfb;">
              <span class="badge-can">✖ Cancelled</span>
              <h3 style="color:#991b1b; font-size:15px;">Booking Ref: ${o.id}</h3>
              <p style="font-size:13.5px; color:#64748b; text-decoration:line-through; margin:5px 0;">🩺 ${o.tests}</p>
              <div class="meta-box" style="background:#fef2f2;">
                <div><b>Voided Amount:</b> ${o.amount}</div>
                <div><b>Cancelled On:</b> ${o.cancelledDate || 'Recently'}</div>
              </div>
            </div>
          `;
        }
      });
      container.innerHTML = html;
    }
  </script>
</body>
</html>
EOF

# ==========================================
# 8. REBUILD & RESTART ALL MICROSERVICES
# ==========================================
docker compose up -d --build booking-service notification-service frontend
c
cd ~/frontend
# =============================================================
# 1. HOMEPAGE (index.html) - FLYING PARTICLE TO CART + NO POPUPS
# =============================================================
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>CareGrid Diagnostics | Trusted Pathology Lab & Diagnostics</title>
  <script>
    if (localStorage.getItem('caregrid_auth') !== 'true') {
      window.location.replace('/login.html');
    }
  </script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif; }
    body { background: #f8fafc; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; font-size: 13.5px; }

    /* Top Utility Bar */
    .topbar { background: #00172e; color: #94a3b8; font-size: 12px; padding: 6px 30px; display: flex; justify-content: space-between; align-items: center; }
    .topbar b { color: #f1f5f9; }
    .btn-callback-top { background: #00a896; color: white; border: none; padding: 4px 14px; border-radius: 14px; font-weight: 700; cursor: pointer; font-size: 11.5px; transition: 0.2s; }
    .btn-callback-top:hover { background: #008f80; }

    /* Header Nav */
    header { background: #ffffff; box-shadow: 0 2px 8px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100; }
    .nav { max-width: 1280px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; padding: 10px 24px; gap: 15px; }
    .logo { font-size: 21px; font-weight: 800; color: #003366; text-decoration: none; display: flex; align-items: center; gap: 4px; }
    .logo span { color: #00a896; }
    
    .search-wrap { position: relative; flex: 1; max-width: 380px; }
    .search-inp { width: 100%; padding: 8px 16px; border: 1.5px solid #cbd5e1; border-radius: 20px; font-size: 12.5px; outline: none; transition: 0.2s; }
    .search-inp:focus { border-color: #00a896; box-shadow: 0 0 0 3px rgba(0,168,150,0.15); }

    .menu { display: flex; list-style: none; gap: 18px; font-weight: 600; font-size: 13.5px; align-items: center; }
    .menu a { color: #334155; text-decoration: none; }
    .menu a:hover { color: #00a896; }

    .actions { display: flex; gap: 10px; align-items: center; }
    .user-pill { background: #e6fffa; color: #003366; border: 1px solid #00a896; padding: 5px 12px; border-radius: 20px; font-weight: 700; font-size: 12px; text-decoration: none; display: flex; align-items: center; gap: 5px; }
    .btn-logout { background: none; border: none; color: #ef4444; font-size: 11px; font-weight: bold; cursor: pointer; text-decoration: underline; margin-left: 4px; }
    
    /* Cart Button Target */
    .btn-cart { id: "cartTargetBtn"; background: #003366; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 700; text-decoration: none; font-size: 12.5px; display: flex; gap: 6px; align-items: center; position: relative; transition: transform 0.2s; }
    .btn-cart.pulse { animation: cartBounce 0.4s ease; }
    @keyframes cartBounce { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.18); background: #00a896; } }
    .badge { background: #00a896; border-radius: 50%; padding: 2px 6px; font-size: 11px; }

    /* Flying Particle for Smooth Dynamic Cart Add */
    .flying-ball {
      position: fixed;
      width: 24px;
      height: 24px;
      background: #00a896;
      border: 2px solid white;
      border-radius: 50%;
      z-index: 9999;
      pointer-events: none;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 11px;
      box-shadow: 0 4px 15px rgba(0,168,150,0.6);
      transition: all 0.65s cubic-bezier(0.16, 1, 0.3, 1);
    }

    /* 3-Second 4-Slide Hero Carousel */
    .carousel-wrapper { position: relative; background: linear-gradient(135deg, #001f3f 0%, #003366 50%, #004d61 100%); color: white; overflow: hidden; height: 195px; }
    .carousel-track { display: flex; transition: transform 0.5s cubic-bezier(0.25, 1, 0.5, 1); width: 400%; height: 100%; }
    .carousel-slide { width: 25%; height: 100%; padding: 16px 30px; display: flex; align-items: center; justify-content: center; }
    .slide-inner { max-width: 1200px; width: 100%; display: flex; justify-content: space-between; align-items: center; gap: 24px; }
    .badge-pill { display: inline-block; background: rgba(255, 255, 255, 0.12); border: 1px solid rgba(0, 168, 150, 0.6); padding: 2px 10px; border-radius: 20px; font-size: 10.5px; font-weight: 700; color: #5eead4; margin-bottom: 5px; }
    .slide-title { font-size: 21px; font-weight: 800; line-height: 1.2; margin-bottom: 4px; }
    .slide-title span { color: #38bdf8; }
    .slide-desc { font-size: 12.5px; color: #cbd5e1; margin-bottom: 10px; max-width: 520px; line-height: 1.35; }
    .btn-slide-cta { background: #00a896; color: white; text-decoration: none; font-weight: 700; font-size: 12px; padding: 6px 16px; border-radius: 16px; display: inline-block; }

    .slide-right-card { background: rgba(15, 23, 42, 0.55); border: 1px solid rgba(255, 255, 255, 0.15); backdrop-filter: blur(8px); padding: 10px 16px; border-radius: 10px; display: flex; align-items: center; gap: 12px; min-width: 270px; }
    .slide-icon { width: 36px; height: 36px; border-radius: 8px; background: rgba(0, 168, 150, 0.25); display: flex; align-items: center; justify-content: center; font-size: 18px; flex-shrink: 0; }
    .slide-meta h4 { font-size: 13px; font-weight: 700; color: #fff; margin-bottom: 2px; }
    .slide-meta p { font-size: 11px; color: #94a3b8; }

    .carousel-indicators { position: absolute; bottom: 6px; left: 50%; transform: translateX(-50%); display: flex; gap: 6px; }
    .c-dot { width: 7px; height: 7px; border-radius: 50%; background: rgba(255,255,255,0.3); transition: 0.3s; cursor: pointer; }
    .c-dot.active { width: 18px; border-radius: 8px; background: #00a896; }

    /* Top 3 Featured Section */
    .main { max-width: 1280px; width: 100%; margin: 16px auto 25px; padding: 0 24px; flex: 1; }
    .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
    .section-title { font-size: 18px; font-weight: 800; color: #003366; }
    .badge-pop { background: #e6fffa; color: #00a896; font-size: 11px; font-weight: 800; padding: 3px 9px; border-radius: 16px; border: 1px solid #99f6e4; }

    .grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; }
    @media (max-width: 850px) { .grid-3 { grid-template-columns: 1fr; } }

    .card { background: white; border-radius: 10px; border: 1px solid #e2e8f0; box-shadow: 0 2px 5px rgba(0,0,0,0.03); display: flex; flex-direction: column; justify-content: space-between; transition: 0.2s; position: relative; }
    .card:hover { transform: translateY(-2px); box-shadow: 0 6px 14px rgba(0,0,0,0.06); border-color: #00a896; }
    .card-body { padding: 15px; }
    .tag { background: #e6fffa; color: #00a896; font-size: 10px; font-weight: 800; text-transform: uppercase; padding: 2px 7px; border-radius: 3px; display: inline-block; margin-bottom: 6px; }
    .title { font-size: 15px; font-weight: 700; color: #003366; margin-bottom: 4px; }
    .desc { font-size: 11.5px; color: #64748b; margin-bottom: 8px; line-height: 1.35; min-height: 30px; }
    .price { font-size: 20px; font-weight: 800; color: #003366; border-top: 1px solid #f1f5f9; padding-top: 8px; }
    .card-footer { padding: 10px 15px; background: #f8fafc; border-top: 1px solid #f1f5f9; display: flex; gap: 8px; border-radius: 0 0 10px 10px; }
    .btn-add { flex: 1; background: white; border: 1.5px solid #003366; color: #003366; border-radius: 5px; padding: 7px 0; font-weight: 700; cursor: pointer; font-size: 12px; transition: 0.2s; }
    .btn-add:hover { background: #003366; color: white; }
    .btn-book { flex: 1; background: #00a896; border: none; color: white; border-radius: 5px; padding: 7px 0; font-weight: 700; cursor: pointer; font-size: 12px; text-align: center; text-decoration: none; }

    /* Static Educational Content Section */
    .edu-section { margin-top: 26px; background: #ffffff; border-radius: 12px; border: 1px solid #e2e8f0; padding: 22px; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
    .edu-title { font-size: 16px; font-weight: 800; color: #003366; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
    .edu-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; }
    @media (max-width: 850px) { .edu-grid { grid-template-columns: 1fr; } }
    .edu-box { background: #f8fafc; padding: 14px 16px; border-radius: 8px; border-left: 3px solid #00a896; }
    .edu-box h4 { color: #003366; font-size: 13.5px; margin-bottom: 4px; font-weight: 700; }
    .edu-box p { color: #64748b; font-size: 12px; line-height: 1.45; }

    /* Toast Notification */
    .toast-msg {
      position: fixed;
      bottom: 24px;
      right: 24px;
      background: #002244;
      color: white;
      padding: 12px 20px;
      border-radius: 8px;
      border-left: 4px solid #00a896;
      box-shadow: 0 10px 25px rgba(0,0,0,0.2);
      font-size: 13px;
      display: none;
      z-index: 10000;
      animation: fadeIn 0.3s;
    }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

    /* Callback Modal */
    .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); backdrop-filter: blur(2px); z-index: 1000; align-items: center; justify-content: center; }
    .modal-card { background: white; border-radius: 12px; width: 90%; max-width: 400px; padding: 26px; box-shadow: 0 20px 25px rgba(0,0,0,0.25); }
    .btn-submit-cb { width: 100%; background: #00a896; color: white; border: none; padding: 12px; border-radius: 6px; font-weight: 700; cursor: pointer; margin-top: 10px; }

    /* Footer */
    footer { background: #001f3f; color: #94a3b8; padding: 35px 24px 15px; margin-top: auto; border-top: 3px solid #00a896; width: 100%; font-size: 12px; }
    .footer-container { max-width: 1280px; margin: 0 auto; display: grid; grid-template-columns: 1.8fr 1fr 1fr 1.6fr; gap: 30px; }
    .footer-col h4 { color: #fff; font-size: 14px; margin-bottom: 12px; }
    .footer-col ul { list-style: none; }
    .footer-col ul li { margin-bottom: 8px; }
    .footer-col ul li a { color: #cbd5e1; text-decoration: none; }
    .footer-col ul li a:hover { color: #00a896; }
    .footer-bottom { max-width: 1280px; margin: 25px auto 0; padding-top: 15px; border-top: 1px solid #1e3a5f; display: flex; justify-content: space-between; }
  </style>
</head>
<body>

  <div class="topbar">
    <div>📞 Helpline: <b>+91 6353468394</b> | ✉️ Support: <b>rajmore2023@gmail.com</b></div>
    <div>
      <button class="btn-callback-top" onclick="openCallback()">📞 Request Call Back</button>
      <span style="margin-left: 10px; color:#10b981;">● 6 Microservices Operational</span>
    </div>
  </div>

  <header>
    <div class="nav">
      <a href="/index.html" class="logo">CARE<span>GRID</span> <small style="font-size:10px; color:#64748b; font-weight:400;">| DIAGNOSTICS</small></a>
      
      <!-- Live Search Bar -->
      <div class="search-wrap">
        <input type="text" class="search-inp" id="homeSearch" placeholder="🔍 Search 35+ tests (CBC, Lipid, Thyroid, Sugar)..." onkeyup="handleSearch(event)">
      </div>

      <ul class="menu">
        <li><a href="/index.html" style="color:#00a896; font-weight:bold;">Home</a></li>
        <li><a href="/services.html">All 35 Services</a></li>
        <li><a href="/cart.html">Shopping Cart</a></li>
        <li><a href="/orders.html">My Bookings</a></li>
      </ul>
      <div class="actions">
        <a href="/orders.html" class="user-pill">
          👤 <span id="userNameNav">Raj More</span>
          <button class="btn-logout" onclick="logout(event)">Logout</button>
        </a>
        <a href="/cart.html" class="btn-cart" id="cartNavBtn">Cart <span class="badge" id="cartBadge">0</span></a>
      </div>
    </div>
  </header>

  <!-- 3-Second 4-Slide Hero Carousel -->
  <div class="carousel-wrapper">
    <div class="carousel-track" id="track">
      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">✓ NABL & ICMR ACCREDITED</span>
            <div class="slide-title">Accurate Diagnostics, <span>At Your Home.</span></div>
            <div class="slide-desc">Painless vacuum-sealed sample collection by certified phlebotomists with zero extra visit fee.</div>
            <a href="/services.html" class="btn-slide-cta">Explore 35 Packages &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">🩺</div>
            <div class="slide-meta"><h4>Free Home Pickup</h4><p>Phlebotomist arrives within 60 mins</p></div>
          </div>
        </div>
      </div>

      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">⚡ 6-HOUR TURNAROUND</span>
            <div class="slide-title">Express Delivery <span>Digital Reports.</span></div>
            <div class="slide-desc">Cold-chain specimen transport with automated barcode tracking and instant PDF alerts.</div>
            <a href="/orders.html" class="btn-slide-cta">Track Live Samples &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">📑</div>
            <div class="slide-meta"><h4>Doctor-Verified Reports</h4><p>Smart NABL-certified PDF reports</p></div>
          </div>
        </div>
      </div>

      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">💵 ZERO ADVANCE PAYMENT</span>
            <div class="slide-title">Cash On Collection, <span>Complete Trust.</span></div>
            <div class="slide-desc">Zero advance card payment. Pay cash or UPI scan directly to collector after blood draw.</div>
            <a href="/services.html" class="btn-slide-cta">Schedule Sample &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">💵</div>
            <div class="slide-meta"><h4>Doorstep Payment</h4><p>Pay phlebotomist after sample drawn</p></div>
          </div>
        </div>
      </div>

      <div class="carousel-slide">
        <div class="slide-inner">
          <div class="slide-left">
            <span class="badge-pill">🛡️ PREVENTIVE HEALTHCARE</span>
            <div class="slide-title">Full Body Health <span>Preventive Checkup.</span></div>
            <div class="slide-desc">Cover vital markers: Heart, Liver, Kidney, Thyroid, Sugar, Vitamin D & B12 in one profile.</div>
            <a href="/services.html" class="btn-slide-cta">View Full Panels &rarr;</a>
          </div>
          <div class="slide-right-card">
            <div class="slide-icon">🧪</div>
            <div class="slide-meta"><h4>Comprehensive Panels</h4><p>Over 80+ essential biomarkers</p></div>
          </div>
        </div>
      </div>
    </div>

    <div class="carousel-indicators">
      <div class="c-dot active" onclick="setSlide(0)"></div>
      <div class="c-dot" onclick="setSlide(1)"></div>
      <div class="c-dot" onclick="setSlide(2)"></div>
      <div class="c-dot" onclick="setSlide(3)"></div>
    </div>
  </div>

  <!-- Top 3 Featured Diagnostic Services -->
  <div class="main">
    <div class="section-header">
      <div class="section-title">Popular Diagnostic Packages</div>
      <div class="badge-pop">Top 3 Most Booked</div>
    </div>

    <div class="grid-3" id="homeGrid"></div>

    <div style="margin-top: 16px; background: #002244; color: white; border-radius: 8px; padding: 12px 20px; display: flex; justify-content: space-between; align-items: center;">
      <div>
        <b>Need Full Body or Specialized Panels?</b>
        <span style="color:#94a3b8; margin-left:6px;">Browse complete 35 test catalog (Heart, Liver, Kidney, Vitamins).</span>
      </div>
      <a href="/services.html" style="background:#00a896; color:white; text-decoration:none; font-weight:700; font-size:12px; padding:7px 18px; border-radius:16px;">View All 35 Services &rarr;</a>
    </div>

    <!-- Informative Static Reading Section -->
    <div class="edu-section">
      <div class="edu-title">📖 Clinical Laboratory Standards & Patient Care Guidelines</div>
      <div class="edu-grid">
        <div class="edu-box">
          <h4>Temperature-Controlled Cold Chain</h4>
          <p>Blood samples are preserved in vacuum-sealed EDTA/Gel tubes at 2°C–8°C ice-pack coolers to prevent hemolysis and guarantee 99.8% precision.</p>
        </div>
        <div class="edu-box">
          <h4>Barcoded Sample Tracking</h4>
          <p>Each phlebotomist visit assigns unique dual-barcoded labels verified against patient ID to ensure zero mix-ups in high-throughput automation.</p>
        </div>
        <div class="edu-box">
          <h4>NABL & ICMR Clinical Sign-Off</h4>
          <p>Every diagnostic profile is independently reviewed by our Senior Clinical Pathologists and Biochemists before releasing digitally signed PDF reports.</p>
        </div>
      </div>
    </div>
  </div>

  <!-- Toast Notification Message (Replaces native browser alert) -->
  <div class="toast-msg" id="toastMsg"></div>

  <!-- Request Call Back Modal -->
  <div class="modal-overlay" id="callbackModal">
    <div class="modal-card">
      <h3 style="color:#003366; font-size:17px; margin-bottom:6px;">Request an Immediate Call Back</h3>
      <p style="color:#64748b; font-size:12px; margin-bottom:14px;">Enter your phone number and our diagnostic specialist will contact you.</p>
      
      <div style="margin-bottom:12px;">
        <label style="font-size:11.5px; font-weight:700; color:#475569;">Your Contact Number</label>
        <input type="text" id="cbPhone" value="6353468394" style="width:100%; padding:9px 12px; border:1.5px solid #cbd5e1; border-radius:6px; font-size:14px; margin-top:4px;">
      </div>

      <div style="margin-bottom:14px;">
        <label style="font-size:11.5px; font-weight:700; color:#475569;">Test Inquiry / Query</label>
        <input type="text" id="cbQuery" value="Need assistance booking Full Body Health Checkup" style="width:100%; padding:9px 12px; border:1.5px solid #cbd5e1; border-radius:6px; font-size:13px; margin-top:4px;">
      </div>

      <button class="btn-submit-cb" onclick="submitCallback()">Submit Call Back Request</button>
      <button onclick="document.getElementById('callbackModal').style.display='none'" style="width:100%; background:none; border:none; color:#64748b; font-size:12px; margin-top:8px; cursor:pointer;">Cancel</button>
    </div>
  </div>

  <footer>
    <div class="footer-container">
      <div class="footer-col">
        <h3 style="color:#fff; font-size:18px; margin-bottom:8px;">CARE<span style="color:#00a896;">GRID</span></h3>
        <p style="line-height:1.6; color:#94a3b8;">Accredited diagnostic pathology network delivering high-accuracy laboratory panels and certified phlebotomy doorstep visits.</p>
      </div>
      <div class="footer-col">
        <h4>Catalog</h4>
        <ul>
          <li><a href="/services.html">All 35 Diagnostic Packages</a></li>
          <li><a href="/services.html">Heart & Cardiac Biomarkers</a></li>
          <li><a href="/services.html">Diabetes Management Profiles</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Patient Services</h4>
        <ul>
          <li><a href="/cart.html">Shopping Cart</a></li>
          <li><a href="/orders.html">My Scheduled Bookings</a></li>
          <li><a href="/orders.html">Cancelled Bookings Record</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Central Helpdesk</h4>
        <p style="color:#cbd5e1; line-height:1.8;">
          📞 <b>Helpline:</b> +91 6353468394<br>
          ✉️ <b>Support:</b> rajmore2023@gmail.com<br>
          📍 <b>Central Lab:</b> SG Highway, Ahmedabad, Gujarat - 380054
        </p>
      </div>
    </div>
    <div class="footer-bottom">
      <div>© 2026 CareGrid Healthcare Technologies Pvt Ltd. All rights reserved.</div>
      <div>Helpline: +91 6353468394 | rajmore2023@gmail.com</div>
    </div>
  </footer>

  <script>
    // Carousel Rotation (3 seconds)
    let currentSlide = 0;
    const track = document.getElementById('track');
    const dots = document.querySelectorAll('.c-dot');
    function updateCarousel() {
      track.style.transform = `translateX(-${currentSlide * 25}%)`;
      dots.forEach((d, idx) => d.classList.toggle('active', idx === currentSlide));
    }
    function setSlide(idx) { currentSlide = idx; updateCarousel(); }
    setInterval(() => { currentSlide = (currentSlide + 1) % 4; updateCarousel(); }, 3000);

    // User & Cart State
    document.getElementById('userNameNav').innerText = localStorage.getItem('caregrid_user_name') || 'Raj More';
    let cart = JSON.parse(localStorage.getItem('caregrid_cart') || '[]');
    document.getElementById('cartBadge').innerText = cart.length;

    // Fetch strictly Top 3 for Homepage
    fetch('/api/catalog/products')
      .then(res => res.json())
      .then(data => {
        const grid = document.getElementById('homeGrid');
        grid.innerHTML = '';
        const top3 = data.tests.slice(0, 3);
        top3.forEach(test => {
          grid.innerHTML += `
            <div class="card" id="card-${test.id}">
              <div class="card-body">
                <span class="tag">${test.category}</span>
                <div class="title">${test.name}</div>
                <div class="desc">🩺 ${test.parameters}</div>
                <div class="price">${test.price}</div>
              </div>
              <div class="card-footer">
                <button class="btn-add" onclick="animateAddToCart(event, '${test.name}', ${test.numPrice})">Add to Cart</button>
                <button class="btn-book" onclick="bookNow('${test.name}', ${test.numPrice})">Instant Book</button>
              </div>
            </div>
          `;
        });
      });

    // SMOOTH FLIGHT ARROW / PARTICLE ANIMATION TO CART
    function animateAddToCart(event, name, price) {
      const btn = event.currentTarget;
      const btnRect = btn.getBoundingClientRect();
      const cartBtn = document.getElementById('cartNavBtn');
      const cartRect = cartBtn.getBoundingClientRect();

      // Create floating particle
      const ball = document.createElement('div');
      ball.className = 'flying-ball';
      ball.innerHTML = '🧪';
      ball.style.left = `${btnRect.left + btnRect.width / 2}px`;
      ball.style.top = `${btnRect.top + btnRect.height / 2}px`;
      document.body.appendChild(ball);

      // Trigger curved flight
      requestAnimationFrame(() => {
        ball.style.left = `${cartRect.left + cartRect.width / 2 - 12}px`;
        ball.style.top = `${cartRect.top + cartRect.height / 2 - 12}px`;
        ball.style.transform = 'scale(0.4)';
        ball.style.opacity = '0.5';
      });

      // Update State after flight completion
      setTimeout(() => {
        ball.remove();
        cart.push({ name, price });
        localStorage.setItem('caregrid_cart', JSON.stringify(cart));
        document.getElementById('cartBadge').innerText = cart.length;

        // Bounce cart icon
        cartBtn.classList.add('pulse');
        setTimeout(() => cartBtn.classList.remove('pulse'), 400);

        // Toast feedback (No disruptive browser alert)
        showToast(`✔ ${name} added to cart!`);
      }, 650);
    }

    function showToast(text) {
      const toast = document.getElementById('toastMsg');
      toast.innerText = text;
      toast.style.display = 'block';
      setTimeout(() => { toast.style.display = 'none'; }, 2200);
    }

    function bookNow(name, price) {
      cart = [{ name, price }];
      localStorage.setItem('caregrid_cart', JSON.stringify(cart));
      window.location.href = '/checkout.html';
    }

    function handleSearch(e) {
      if (e.key === 'Enter') {
        const val = document.getElementById('homeSearch').value.trim();
        window.location.href = '/services.html?search=' + encodeURIComponent(val);
      }
    }

    function openCallback() {
      document.getElementById('callbackModal').style.display = 'flex';
    }

    function submitCallback() {
      const phone = document.getElementById('cbPhone').value.trim();
      const query = document.getElementById('cbQuery').value.trim();
      
      fetch('/api/notification/callback', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ phone, query })
      })
      .then(r => r.json())
      .then(res => {
        document.getElementById('callbackModal').style.display = 'none';
        showToast(`✅ Call back requested! Ref: ${res.request.id}`);
      })
      .catch(() => {
        document.getElementById('callbackModal').style.display = 'none';
        showToast(`✅ Call back requested for ${phone}`);
      });
    }

    function logout(e) {
      e.preventDefault();
      localStorage.removeItem('caregrid_auth');
      window.location.href = '/login.html';
    }
  </script>
</body>
</html>
EOF

# =============================================================
# 2. CART SERVICE (cart.html) - INSTANT CHECKOUT & CLEAR FLOW
# =============================================================
cat << 'EOF' > cart.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>CareGrid Diagnostics | Shopping Cart Service</title>
  <script>
    if (localStorage.getItem('caregrid_auth') !== 'true') window.location.replace('/login.html');
  </script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Roboto, sans-serif; }
    body { background: #f8fafc; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; font-size: 13.5px; }
    header { background: #fff; padding: 12px 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
    .logo { font-size: 20px; font-weight: 800; color: #003366; text-decoration: none; }
    .logo span { color: #00a896; }
    .container { max-width: 950px; width: 100%; margin: 30px auto 50px; padding: 0 20px; flex: 1; }
    .cart-grid { display: grid; grid-template-columns: 1.8fr 1.2fr; gap: 24px; }
    @media (max-width: 768px) { .cart-grid { grid-template-columns: 1fr; } }
    .card { background: white; border-radius: 10px; border: 1px solid #e2e8f0; padding: 20px; box-shadow: 0 2px 6px rgba(0,0,0,0.03); }
    .item-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f1f5f9; }
    .btn-del { color: #ef4444; background: none; border: none; cursor: pointer; font-size: 12px; font-weight: bold; }
    .btn-checkout { width: 100%; background: #00a896; color: white; border: none; padding: 13px; border-radius: 6px; font-weight: 700; font-size: 14.5px; cursor: pointer; margin-top: 15px; text-align: center; display: block; text-decoration: none; box-shadow: 0 4px 12px rgba(0,168,150,0.3); }
    .btn-checkout:hover { background: #008f80; }
  </style>
</head>
<body>
  <header>
    <a href="/index.html" class="logo">CARE<span>GRID</span> <small style="font-size:11px; color:#64748b;">| CART SERVICE</small></a>
    <div style="display:flex; gap:16px; align-items:center;">
      <a href="/services.html" style="color:#00a896; text-decoration:none; font-weight:700;">+ Browse 35 Tests</a>
      <a href="/orders.html" style="color:#003366; text-decoration:none; font-weight:700;">My Bookings</a>
    </div>
  </header>

  <div class="container">
    <h2 style="color:#003366; font-size:20px; margin-bottom:16px;">Diagnostic Cart Review</h2>
    <div class="cart-grid">
      <div class="card">
        <h3 style="font-size:15px; margin-bottom:12px; color:#003366;">Selected Health Packages</h3>
        <div id="cartItemsList"></div>
      </div>
      
      <div class="card" style="height: fit-content;">
        <h3 style="font-size:15px; margin-bottom:12px; color:#003366;">Price Breakdown</h3>
        <div style="display:flex; justify-content:space-between; margin-bottom:10px; color:#64748b;">
          <span>Home Sample Collection:</span><span style="color:#16a34a; font-weight:700;">FREE (₹0)</span>
        </div>
        <div style="display:flex; justify-content:space-between; margin-bottom:16px; font-size:18px; font-weight:800; color:#003366; border-top:1px solid #f1f5f9; padding-top:12px;">
          <span>Total Payable:</span><span id="cartGrandTotal">₹0</span>
        </div>
        <a href="/checkout.html" id="checkoutBtn" class="btn-checkout">Confirm & Proceed to Doorstep Booking &rarr;</a>
      </div>
    </div>
  </div>

  <script>
    let cart = JSON.parse(localStorage.getItem('caregrid_cart') || '[]');

    function renderCart() {
      const list = document.getElementById('cartItemsList');
      if (cart.length === 0) {
        list.innerHTML = '<p style="color:#64748b; padding:25px 0; text-align:center;">Your cart is empty.<br><a href="/services.html" style="color:#00a896; font-weight:bold; margin-top:8px; display:inline-block;">Explore 35 Diagnostic Packages</a></p>';
        document.getElementById('cartGrandTotal').innerText = '₹0';
        document.getElementById('checkoutBtn').style.display = 'none';
        return;
      }
      let html = '';
      let sum = 0;
      cart.forEach((item, index) => {
        sum += item.price;
        html += `
          <div class="item-row">
            <div>
              <b style="color:#003366; font-size:14px;">${item.name}</b>
              <div style="color:#00a896; font-weight:700; margin-top:2px;">₹${item.price}</div>
            </div>
            <button class="btn-del" onclick="removeItem(${index})">Remove</button>
          </div>
        `;
      });
      list.innerHTML = html;
      document.getElementById('cartGrandTotal').innerText = '₹' + sum;
      document.getElementById('checkoutBtn').style.display = 'block';
    }

    function removeItem(index) {
      cart.splice(index, 1);
      localStorage.setItem('caregrid_cart', JSON.stringify(cart));
      renderCart();
    }
    renderCart();
  </script>
</body>
</html>
EOF

# =============================================================
# 3. DIRECT DOCKER CONTAINER INJECTION
# =============================================================
docker cp index.html $(docker compose ps -q frontend):/usr/share/nginx/html/index.html
docker cp cart.html $(docker compose ps -q frontend):/usr/share/nginx/html/cart.html
clear
cd ..
