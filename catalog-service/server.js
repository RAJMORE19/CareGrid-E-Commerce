const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors());

const tests = [
  // Top 6 Featured Homepage Packages
  { id: "T101", name: "Complete Blood Count (CBC)", price: "₹399", numPrice: 399, category: "Hematology", parameters: "24 Blood Markers (Platelets, RBC, WBC, Hemoglobin)", homeFeatured: true },
  { id: "T102", name: "Comprehensive Lipid Profile", price: "₹899", numPrice: 899, category: "Heart", parameters: "8 Parameters (Total Cholesterol, HDL, LDL, VLDL, Triglycerides)", homeFeatured: true },
  { id: "T103", name: "Advanced Thyroid Panel (T3, T4, TSH)", price: "₹799", numPrice: 799, category: "Thyroid", parameters: "Total T3, Total T4 & Ultrasensitive TSH Hormone", homeFeatured: true },
  { id: "T104", name: "HbA1c (Glycated Hemoglobin)", price: "₹599", numPrice: 599, category: "Diabetes", parameters: "3-Month Blood Glucose Average & Estimated Mean Sugar", homeFeatured: true },
  { id: "T105", name: "Senior Citizen Comprehensive Health", price: "₹1,999", numPrice: 1999, category: "Preventive", parameters: "72 Vital Organs Parameters (Kidney, Liver, Heart, Electrolytes)", homeFeatured: true },
  { id: "T106", name: "Liver Function Test (LFT)", price: "₹699", numPrice: 699, category: "Liver", parameters: "12 Markers (SGOT, SGPT, Bilirubin Direct/Total, Protein)", homeFeatured: true },

  // Remaining 29 Diagnostic Tests (Total 35)
  { id: "T107", name: "Vitamin D3 (25-Hydroxy)", price: "₹1,199", numPrice: 1199, category: "Vitamins", parameters: "Serum Calcidiol Levels & Bone Health Assessment", homeFeatured: false },
  { id: "T108", name: "Vitamin B12 (Cyanocobalamin)", price: "₹999", numPrice: 999, category: "Vitamins", parameters: "Nerve Function, RBC Formation & Energy Metabolism", homeFeatured: false },
  { id: "T109", name: "Renal / Kidney Function Test (KFT)", price: "₹749", numPrice: 749, category: "Kidney", parameters: "Urea, Blood Urea Nitrogen, Creatinine & Uric Acid", homeFeatured: false },
  { id: "T110", name: "Fasting Blood Sugar (Glucose)", price: "₹149", numPrice: 149, category: "Diabetes", parameters: "Plasma Glucose Concentration After 8-10 Hrs Fasting", homeFeatured: false },
  { id: "T111", name: "Post-Prandial Blood Sugar (PPBS)", price: "₹149", numPrice: 149, category: "Diabetes", parameters: "Post-Meal Glucose Assessment for Insulin Response", homeFeatured: false },
  { id: "T112", name: "Cardiac Risk Biomarker (hs-CRP)", price: "₹849", numPrice: 849, category: "Heart", parameters: "High Sensitivity C-Reactive Protein for Heart Inflammation", homeFeatured: false },
  { id: "T113", name: "Iron Deficiency Profile", price: "₹899", numPrice: 899, category: "Hematology", parameters: "Serum Iron, Ferritin, Transferrin Saturation & TIBC", homeFeatured: false },
  { id: "T114", name: "Total Prostate Specific Antigen (PSA)", price: "₹850", numPrice: 850, category: "Preventive", parameters: "Prostate Screening & Men's Health Marker", homeFeatured: false },
  { id: "T115", name: "Serum Electrolytes Panel", price: "₹550", numPrice: 550, category: "Kidney", parameters: "Sodium (Na+), Potassium (K+), Chloride (Cl-) Levels", homeFeatured: false },
  { id: "T116", name: "Erythrocyte Sedimentation Rate (ESR)", price: "₹199", numPrice: 199, category: "Hematology", parameters: "Systemic Inflammatory Response & Autoimmune Marker", homeFeatured: false },
  { id: "T117", name: "Urine Routine & Microscopic Exam", price: "₹249", numPrice: 249, category: "Kidney", parameters: "pH, Specific Gravity, Pus Cells, Crystals & Protein", homeFeatured: false },
  { id: "T118", name: "Dual Vitamin Master Panel (D3 + B12)", price: "₹1,899", numPrice: 1899, category: "Vitamins", parameters: "Complete Bone & Neurological Health Assessment", homeFeatured: false },
  { id: "T119", name: "D-Dimer Coagulation Test", price: "₹1,250", numPrice: 1250, category: "Heart", parameters: "Thrombosis & Blood Clotting Factor Evaluation", homeFeatured: false },
  { id: "T120", name: "Serum Uric Acid Test", price: "₹299", numPrice: 299, category: "Kidney", parameters: "Gout & Hyperuricemia Metabolic Screening", homeFeatured: false },
  { id: "T121", name: "Serum Calcium Total", price: "₹280", numPrice: 280, category: "Preventive", parameters: "Bone Mineralization & Parathyroid Evaluation", homeFeatured: false },
  { id: "T122", name: "Total IgE Allergy Marker", price: "₹899", numPrice: 899, category: "Preventive", parameters: "Allergic Reactions & Immunoglobulin Profiling", homeFeatured: false },
  { id: "T123", name: "Lipoprotein (a) [Lp(a)]", price: "₹1,099", numPrice: 1099, category: "Heart", parameters: "Genetically Inherited Cardiovascular Risk Factor", homeFeatured: false },
  { id: "T124", name: "Executive Full Body Wellness Panel", price: "₹2,499", numPrice: 2499, category: "Preventive", parameters: "84 Parameters (Complete Cardiac, Hepatic, Renal, Vitamins)", homeFeatured: false },
  { id: "T125", name: "Women's Hormonal Health Profile", price: "₹2,199", numPrice: 2199, category: "Preventive", parameters: "PCOS/PCOD & Metabolic Markers (LH, FSH, Prolactin)", homeFeatured: false },
  { id: "T126", name: "Serum Ferritin (Iron Storage)", price: "₹599", numPrice: 599, category: "Hematology", parameters: "Cellular Iron Storage & Anemia Diagnostic Marker", homeFeatured: false },
  { id: "T127", name: "Apolipoprotein A1 & B Panel", price: "₹950", numPrice: 950, category: "Heart", parameters: "Atherosclerosis & Coronary Artery Disease Marker", homeFeatured: false },
  { id: "T128", name: "Free Thyroxine (Free T4)", price: "₹450", numPrice: 450, category: "Thyroid", parameters: "Active Circulating Thyroid Hormone Assessment", homeFeatured: false },
  { id: "T129", name: "Free Triiodothyronine (Free T3)", price: "₹450", numPrice: 450, category: "Thyroid", parameters: "Unbound Cellular T3 Biological Action Marker", homeFeatured: false },
  { id: "T130", name: "Serum Amylase & Lipase", price: "₹850", numPrice: 850, category: "Liver", parameters: "Pancreatic Enzyme Health & Inflammation Indicator", homeFeatured: false },
  { id: "T131", name: "Serum Magnesium", price: "₹420", numPrice: 420, category: "Kidney", parameters: "Neuromuscular Transmission & Electrolyte Stability", homeFeatured: false },
  { id: "T132", name: "Troponin-I High Sensitive", price: "₹1,450", numPrice: 1450, category: "Heart", parameters: "Myocardial Injury & Acute Coronary Syndrome Biomarker", homeFeatured: false },
  { id: "T133", name: "Rheumatoid Factor (RF Quantitative)", price: "₹650", numPrice: 650, category: "Preventive", parameters: "Autoimmune Joint Pain & Arthritis Diagnostic", homeFeatured: false },
  { id: "T134", name: "Anti-Thyroid Peroxidase (Anti-TPO)", price: "₹1,250", numPrice: 1250, category: "Thyroid", parameters: "Hashimoto's & Autoimmune Thyroid Disease Profile", homeFeatured: false },
  { id: "T135", name: "Pre-Marital & Wellness Screening", price: "₹3,499", numPrice: 3499, category: "Preventive", parameters: "96 Comprehensive Markers including Genetic Thalassemia Screening", homeFeatured: false }
];

app.get('/health', (req, res) => res.json({ status: 'UP', service: 'catalog-service' }));
app.get('/products', (req, res) => res.json({ status: 'SUCCESS', total: tests.length, tests }));
app.listen(5003, () => console.log('Catalog Service running on port 5003 with 35 tests'));
