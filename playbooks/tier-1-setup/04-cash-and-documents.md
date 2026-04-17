# Cash & Documents

The paperwork and cash prep that keeps a disaster from becoming a second disaster six months later (lost records, denied claims, locked accounts).

## If you only read one line

**Lose the paper, lose the claim.** Photo every critical document, encrypt the copies, store in three places. Takes one evening. Pays off every time something goes sideways.

## Cash

### How much

Rough tiers:

- **On hand at all times** (wallet or home): $200–500 in small bills ($20s and below).
- **In the car glovebox**: $100–200.
- **In each go-bag**: $100 per person.
- **In the home stash**: $500–1,500 depending on your comfort and means.

Why small bills: in an emergency, cashiers don't make change for a $100. $1s, $5s, $10s, $20s.

Why cash matters: ATMs go down. Card networks go down. Power outages close point-of-sale systems. A week after a major disaster, cash is accepted; cards may not be.

### Where to keep it

- Home stash: not the kitchen drawer, not under the mattress. Common suggestions: taped inside a furniture piece, inside a book (actually in a hollowed one if you're ambitious), inside a waterproof bag in the freezer (yes, really). Multiple small stashes are better than one big one.
- Not the safe. Thieves take safes. A small-bill distributed stash is less attractive.
- Go-bag cash in a ziploc inside the bag, not a loose pocket.

### What about gold, silver, crypto?

- **Gold/silver**: useful for very long horizons (multi-year currency collapse). Not practical for short-to-medium crises. A silver coin won't buy you a loaf of bread because nobody knows what to do with it. Cash is the right tier for 90%+ of disasters.
- **Crypto**: useless without internet and power. If you hold it, hold your own keys (not on an exchange), know how to recover, and treat it as a long-term asset, not an emergency fund.
- **Foreign currency**: only relevant if you travel or live near a border.

## Documents to photograph

Put these on an encrypted USB and in encrypted cloud storage (see below):

### Identity

- Driver's license (front and back)
- Passport (photo page and any visa pages)
- Social Security card (or equivalent national ID)
- Birth certificate
- Marriage certificate / divorce decree if applicable
- Child's birth certificates and Social Security cards
- Pet registration / microchip records

### Residency

- Lease or property deed
- Mortgage statement
- Homeowner's / renter's insurance policy (declaration page)
- Flood / earthquake insurance if applicable
- Most recent utility bill (proves address)

### Medical

- Health insurance cards (all members)
- Current prescription labels (name, dose, prescribing doctor)
- Immunization records (especially children)
- Primary care doctor name/contact
- Any medical equipment model/serial numbers (CPAP, oxygen, hearing aids)
- Advance directives, DNR, durable power of attorney

### Financial

- Bank account numbers (just the account — never photograph the bank letter with password)
- Credit card fronts (the number is replaceable; the issuer's phone number is on the back)
- Recent statement from each account
- Retirement / investment account list (broker + last 4 digits of account)
- Most recent tax return (first and signature pages only)
- W-2s from current year
- List of auto-pay and recurring charges (helps you cancel them if you lose cards)

### Insurance

- Auto insurance policy
- Life insurance policy
- Disability policy
- Umbrella policy
- Contact numbers for each claims line

### Property inventory

This is the single highest-ROI item after a house fire or flood:

- Walk through every room with your phone in video mode. Narrate what you see ("this is the dining room, oak table from 2019, six chairs, china cabinet contains..."). 10-minute video.
- Open closets, drawers, cabinets during the video.
- Do the garage, basement, attic.
- Photograph high-value items individually (jewelry, electronics, instruments, firearms — with serial numbers visible).
- Save receipts for anything significant.

After a loss, insurance claims are bounded by what you can prove. This video is worth many thousands of dollars.

### Contacts

- Family / emergency contact list with out-of-area contact (see [`05-family-comms-plan.md`](05-family-comms-plan.md))
- Attorney (if you have one)
- Accountant (if you have one)
- Employer HR contact
- School emergency contacts
- Veterinarian

## How to store

### Encrypted USB drive

- Use a hardware-encrypted USB (Kingston IronKey, Apricorn Aegis) or a software-encrypted regular USB (VeraCrypt container, 7-Zip AES-256 archive).
- Password known to you and one trusted person (your out-of-area contact, spouse, adult child).
- Keep one in your home, one in your go-bag, one off-site (work, friend's house).
- Update every 6 months or when a major document changes.

### Encrypted cloud

- Any mainstream service (iCloud, Google Drive, OneDrive, Dropbox) is encrypted in transit and at rest. Good enough for most people.
- For higher security: create a password-protected zip (7-Zip with AES-256) before uploading. Strong password.
- For maximum security: Cryptomator or similar end-to-end encrypted layer on top of cloud storage.
- **Turn on 2FA** for the cloud account. See [`06-digital-hardening.md`](06-digital-hardening.md).

### Paper copies

- Keep originals of birth certificates, Social Security cards, passports in a fireproof / waterproof container at home. Sentry SafeGuard or similar, ~$50.
- Carry photocopies, not originals, on evacuation.
- Never keep the only copy of anything in one place.

## What to grab if you have 5 minutes to leave

Priority order, if you cannot take the documents container as a whole:

1. Prescription medications (irreplaceable in a crisis window)
2. Wallet + phone + charger
3. Critical ID: at minimum one form of photo ID per person
4. The encrypted USB
5. Cash stash
6. Kids' / elderly meds and mobility aids
7. Pet carriers and leashes
8. Irreplaceable personal items (photo album, hard drive of family videos, one object you'd grieve)

That's it. Everything else is furniture.

## Account recovery

A subtle but important point: if you lose your phone and your home in the same event, a bad cloud-login recovery flow can strand you.

- **Don't rely on SMS 2FA alone.** If your phone is gone, SMS codes don't arrive.
- **Set up recovery codes** for every major account (Google, Apple ID, Facebook, banks). Print them. Put them in your encrypted USB and in your go-bag document pouch.
- **Hardware security keys** (YubiKey) are the gold standard. Two of them — primary on your person, backup in your home or safe-deposit box.

See [`06-digital-hardening.md`](06-digital-hardening.md).

## After an incident: the paperwork recovery flow

If you lost documents in a fire, flood, or evacuation:

1. **Replace ID**: state DMV for driver's license, passport office for passport. Many states have expedited disaster-replacement processes.
2. **Social Security card**: SSA via mail or in-person.
3. **Birth certificate**: state vital records office (varies by state).
4. **Insurance claim**: file within policy deadline (often 30–60 days). Use your property inventory video.
5. **Bank / credit cards**: call the number on the back. They'll mail replacements — ideally to a trusted address if yours is unstable.
6. **Medical records**: most providers can re-issue. Your pharmacy has prescription history.
7. **IRS**: request tax return transcripts via `irs.gov` for free.

FEMA disaster assistance covers some recovery costs for federally-declared disasters. Register early; funds run out.

## Before it happens, do this once

1. Tonight: photograph your driver's license, insurance cards, and passport. Save to your phone's secure folder.
2. This weekend: walk through your home with video on. Narrate.
3. This month: build the encrypted USB. Put it somewhere safe. Copy to the cloud.
4. Tell your out-of-area contact what to do if you call asking them to "activate the document backup."
