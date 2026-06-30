-- Add referral columns to profiles
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS referral_code TEXT UNIQUE,
ADD COLUMN IF NOT EXISTS referred_by TEXT,
ADD COLUMN IF NOT EXISTS bonus_scans INT NOT NULL DEFAULT 0;

-- Create referral code on profile insert (random 8-char uppercase alphanumeric)
CREATE OR REPLACE FUNCTION public.generate_referral_code()
RETURNS TRIGGER AS $$
BEGIN
  NEW.referral_code := UPPER(SUBSTRING(MD5(NEW.id::TEXT || EXTRACT(EPOCH FROM NOW())::TEXT) FROM 1 FOR 8));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_referral_code ON public.profiles;
CREATE TRIGGER set_referral_code
BEFORE INSERT ON public.profiles
FOR EACH ROW EXECUTE PROCEDURE public.generate_referral_code();

-- Referrals tracking table
CREATE TABLE IF NOT EXISTS public.referrals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  referrer_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  referred_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  bonus_granted BOOLEAN DEFAULT FALSE
);

ALTER TABLE public.referrals ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users read own referrals" ON public.referrals;
CREATE POLICY "Users read own referrals" ON public.referrals
  FOR SELECT USING (auth.uid() = referrer_id);

-- Function to grant bonus scans when referral signs up and completes first scan
CREATE OR REPLACE FUNCTION public.grant_referral_bonus(referred_user_id UUID)
RETURNS VOID AS $$
DECLARE
  referrer UUID;
BEGIN
  SELECT referrer_id INTO referrer FROM public.referrals
  WHERE referred_id = referred_user_id AND bonus_granted = FALSE;

  IF referrer IS NOT NULL THEN
    UPDATE public.profiles SET bonus_scans = bonus_scans + 2 WHERE id = referrer;
    UPDATE public.profiles SET bonus_scans = bonus_scans + 2 WHERE id = referred_user_id;
    UPDATE public.referrals SET bonus_granted = TRUE WHERE referred_id = referred_user_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
