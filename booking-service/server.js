const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors());
app.use(express.json());

let databaseBookings = [];
let dailyCounters = {};

function generateDailyBookingId() {
  const now = new Date();
  const dd = String(now.getDate()).padStart(2, '0');
  const mm = String(now.getMonth() + 1).padStart(2, '0');
  const yyyy = now.getFullYear();
  const dateKey = `${dd}${mm}${yyyy}`; // e.g., 02092026

  if (!dailyCounters[dateKey]) {
    dailyCounters[dateKey] = 1;
  } else {
    dailyCounters[dateKey]++;
  }

  return `${dateKey}${dailyCounters[dateKey]}`; // e.g., 020920261
}

app.get('/health', (req, res) => res.json({ status: 'UP', service: 'booking-service' }));

app.post('/book', (req, res) => {
  const { patient, phone, address, tests, amount } = req.body;
  const bookingId = generateDailyBookingId();

  const newBooking = {
    id: bookingId,
    patient: patient || 'Raj More',
    phone: phone || '6353468394',
    address: address || 'Plot 42, Satellite Area, Ahmedabad, Gujarat - 380054',
    tests: tests || 'Comprehensive Diagnostic Profile',
    amount: amount || '₹399',
    date: new Date().toLocaleDateString('en-IN', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' }),
    status: 'Active',
    dispatchTime: 'Within 1 Hour',
    collector: 'Sunil Varma (Vaccinated Phlebotomist)'
  };

  databaseBookings.unshift(newBooking);
  console.log(`[DB SUCCESS] Stored Booking ID: ${bookingId} for ${newBooking.patient}`);
  res.json({ success: true, booking: newBooking });
});

app.get('/list', (req, res) => res.json({ total: databaseBookings.length, bookings: databaseBookings }));

app.post('/cancel', (req, res) => {
  const { id } = req.body;
  const b = databaseBookings.find(x => x.id === id);
  if (b) {
    b.status = 'Cancelled';
    b.cancelledDate = new Date().toLocaleDateString('en-IN', { day: '2-digit', month: '2-digit', year: 'numeric' });
    return res.json({ success: true, booking: b });
  }
  res.status(404).json({ success: false, message: 'Booking not found' });
});

app.listen(5004, () => console.log('Booking Service running on port 5004'));
