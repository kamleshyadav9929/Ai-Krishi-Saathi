-- =========================================================================
-- AI Krishi Saathi (एआई कृषि साथी) — Production Supabase Schema
-- Developer: Kamlesh Yadav (BIT Mesra - Patna Campus)
-- Project: https://kajibfzadfzfxborexsn.supabase.co
-- =========================================================================

-- 1. AI Crop Leaf Diagnoses Table (फसल रोग पहचान)
CREATE TABLE IF NOT EXISTS public.crop_diagnoses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "diseaseName" TEXT NOT NULL,
    "diseaseNameHindi" TEXT,
    "cropType" TEXT,
    "confidence" NUMERIC,
    "symptoms" JSONB,
    "symptomsHindi" JSONB,
    "organicTreatments" JSONB,
    "organicTreatmentsHindi" JSONB,
    "safetyWarning" TEXT,
    "safetyWarningHindi" TEXT,
    "scannedAt" TIMESTAMPTZ DEFAULT now(),
    "imagePath" TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Farm Ledger & Expense Records Table (खेत खाता-बही व व्यय)
CREATE TABLE IF NOT EXISTS public.farm_expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category TEXT NOT NULL,
    category_hindi TEXT,
    amount NUMERIC NOT NULL DEFAULT 0.0,
    expense_date DATE DEFAULT CURRENT_DATE,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Soil Test & Sowing Advisor Recommendations Table (मृदा परीक्षण व फसल अनुशंसा)
CREATE TABLE IF NOT EXISTS public.soil_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nitrogen NUMERIC,
    phosphorus NUMERIC,
    potassium NUMERIC,
    ph NUMERIC,
    temperature NUMERIC,
    humidity NUMERIC,
    rainfall NUMERIC,
    recommended_crop TEXT,
    recommended_crop_hindi TEXT,
    confidence NUMERIC,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 4. Farmer Profile Table (किसान प्रोफाइल व प्राथमिक जानकारी)
CREATE TABLE IF NOT EXISTS public.farmer_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name TEXT NOT NULL,
    phone_number TEXT,
    state TEXT,
    district TEXT,
    total_land_acres NUMERIC,
    preferred_language TEXT DEFAULT 'hi',
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- =========================================================================
-- Security: Enable Row Level Security (RLS) on all tables
-- =========================================================================
ALTER TABLE public.crop_diagnoses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.farm_expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.soil_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.farmer_profiles ENABLE ROW LEVEL SECURITY;

-- =========================================================================
-- Public Access Policies for Prototype & Flutter Mobile Client
-- =========================================================================

-- crop_diagnoses
CREATE POLICY "Allow public read on crop_diagnoses"
ON public.crop_diagnoses FOR SELECT TO anon, authenticated USING (true);

CREATE POLICY "Allow public insert on crop_diagnoses"
ON public.crop_diagnoses FOR INSERT TO anon, authenticated WITH CHECK (true);

-- farm_expenses
CREATE POLICY "Allow public read on farm_expenses"
ON public.farm_expenses FOR SELECT TO anon, authenticated USING (true);

CREATE POLICY "Allow public insert on farm_expenses"
ON public.farm_expenses FOR INSERT TO anon, authenticated WITH CHECK (true);

-- soil_recommendations
CREATE POLICY "Allow public read on soil_recommendations"
ON public.soil_recommendations FOR SELECT TO anon, authenticated USING (true);

CREATE POLICY "Allow public insert on soil_recommendations"
ON public.soil_recommendations FOR INSERT TO anon, authenticated WITH CHECK (true);

-- farmer_profiles
CREATE POLICY "Allow public read on farmer_profiles"
ON public.farmer_profiles FOR SELECT TO anon, authenticated USING (true);

CREATE POLICY "Allow public insert on farmer_profiles"
ON public.farmer_profiles FOR INSERT TO anon, authenticated WITH CHECK (true);

CREATE POLICY "Allow public update on farmer_profiles"
ON public.farmer_profiles FOR UPDATE TO anon, authenticated USING (true);
