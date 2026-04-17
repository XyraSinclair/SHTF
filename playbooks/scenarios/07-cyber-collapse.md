# Cyber Collapse

A major cybersecurity incident on infrastructure. Banking, payment networks, utilities, telecom, hospital systems, or logistics — partially or fully degraded. Power may be on; internet may not be. This is the "reactive" playbook; for preventive personal hardening, see [`../tier-1-setup/06-digital-hardening.md`](../tier-1-setup/06-digital-hardening.md).

## If you only read one line

**This is a logistics scenario, not a Hollywood scenario. You don't defend against it with a firewall — you defend against it with cash, documents, stored food, a working phone number, and patience while large institutions recover.**

## What "cyber collapse" actually looks like

Not one scenario — several shaped similarly:

1. **Ransomware on payment rails or banking.** Card transactions fail; ATMs down; direct deposits delayed. Example: Colonial Pipeline (2021), ICBC (2023).
2. **Hospital/healthcare systems crippled.** Appointments canceled, EHR unavailable, diversion of ambulances. Example: Change Healthcare (2024).
3. **Telecom outage or fraud event.** Cell networks partial, SMS unreliable, some services affected.
4. **Utility grid event with cyber origin.** Power or water disrupted in a region. Rare but documented (Ukraine 2015).
5. **Broad supply chain compromise.** A key software vendor compromised (SolarWinds-style) affecting many downstream services for weeks.
6. **Combination events.** Multiple sectors affected at once, intentionally or cascading.

Most of these resolve in days to weeks. Almost none last months. The narrative of "the internet is gone forever" does not match any actual historical cyber incident.

## First 24 hours

### Verify before acting

- Confirm the incident is real via **multiple independent sources**: radio, TV, reputable news via web if reachable, official government channels.
- Social media is heavily poisoned by misinformation during these events.
- If internet is partial, try alternate paths (mobile data vs. home WiFi, different DNS, different apps).

### Protect your money and accounts

- **Do not panic-withdraw** from working institutions. Bank runs make everyone worse off. Withdraw only the cash you realistically need for 1–2 weeks.
- If **your** bank is affected: call their published number (not search results — those can be spoofed). Document every call: who you spoke to, when, and what they committed to.
- **Screenshot account balances** and recent transactions if you still have access. Proof-of-balance is useful if records are later disputed.
- **Do not respond to unsolicited communications** about the incident. Attackers impersonate fraud departments during every major event to harvest credentials.
- If **your bank card is compromised**: call the number on the back. Get a replacement card.

### Protect your identity

- Freeze credit at all three bureaus if not already done (see [`../tier-1-setup/06-digital-hardening.md`](../tier-1-setup/06-digital-hardening.md)). Freezing *during* an incident is fine and easy.
- If you suspect your identity is exposed in the specific breach: add a fraud alert (free, 90 days) or full freeze (free, indefinite).
- Monitor statements weekly for 3–6 months after.

### Protect your devices

- If a breach notification mentions your accounts: change passwords on those accounts, plus any account where you reused the password. (You did not reuse passwords, because you have a password manager. Right?)
- **Watch for phishing** exploiting the incident. Scammers send fake "your bank was hacked, click here" emails. Never click; go to the app or site directly.
- Keep operating systems and browsers patched.

### Protect your household

- Discuss with family: we will not share any sensitive info over phone, text, or email with anyone we didn't initiate contact with.
- Teach kids and elderly household members: if "the bank calls," hang up and call the bank's published number directly.

## First 72 hours

### If payment systems are widely down

- **Cash-only**: shops that stay open will accept cash. See [`../tier-1-setup/04-cash-and-documents.md`](../tier-1-setup/04-cash-and-documents.md) for your cash reserve.
- **Checks**: some businesses accept personal checks in crisis; most do not due to fraud risk. Cashier's checks from a working institution are more broadly accepted.
- **Gift cards** (Visa/Mastercard prepaid) sometimes continue functioning through outages — they clear on different rails.
- **Employer direct deposits** delayed: your employer will resolve eventually. Your bank will *usually* honor pending deposits by extending grace periods or waiving overdraft fees — ask.

### If telecom is partially down

- **Text over voice**: SMS often routes when voice doesn't.
- **WiFi calling**: any reachable WiFi (coffee shop, neighbor) can carry voice/text over IP.
- **Ham / GMRS radio**: if you have one, use it. See `radio/UV-5R_Quick_Reference_Card.pdf`.
- **Long-distance family first**: your out-of-area contact (see [`../tier-1-setup/05-family-comms-plan.md`](../tier-1-setup/05-family-comms-plan.md)) becomes the coordination point.

### If internet is partial or unreliable

This is the most common cyber-incident reality. Some services work, some don't.

- **Work**: assume connectivity is unstable. Save work locally frequently. Use cached files.
- **Reference information**: this is where your offline stack shines. See below.

### If hospital systems are down

- **Emergency care continues** — paper charting is standard fallback.
- **Elective care delayed** — reschedule or wait.
- **Prescription fills**: pharmacies usually have paper backup processes. Bring your prescription bottle with info.
- **Your doctor's records**: typically preserved; some back-and-forth with previous records may be slow.

### If utility (power, water) is affected

- Treat as grid-down (see [`05-grid-down-extended.md`](05-grid-down-extended.md)).
- Cyber origin doesn't change the response — you still need water, food, heat/cool, and information.

## Week 1–2

Most major cyber incidents are resolved or have operational workarounds within 1–2 weeks. During this period:

- **Tight finances**: spend deliberately. Cash conservation. Grocery runs, not discretionary purchases.
- **Alternate service paths**: if your usual bank is down, a second bank (see [`../tier-1-setup/06-digital-hardening.md`](../tier-1-setup/06-digital-hardening.md)) is your lifeline.
- **Don't take attractive "emergency" loans or offers.** Scams peak during incidents.
- **Document impacts**: if you have losses from the incident (missed payments triggering fees, etc.), keep a log. Courts and regulators often order compensation after major events.

## Stabilization

### After the incident

- Change passwords on any account that may have been exposed.
- Enable 2FA if not enabled (why did you wait?).
- If your financial records were affected, request 60-day credit monitoring from your bank (often free post-incident).
- Watch for secondary fraud attempts in the weeks after. Stolen data is often sold, then used 3–12 months later when attention has shifted.
- If identity was stolen: file with IdentityTheft.gov (US) and follow the recovery plan.

### Long-term

- Diversify: multiple banks, multiple payment methods, multiple communication channels.
- Reduce attack surface: close unused accounts, remove stored cards from sites you rarely buy from.
- Keep the offline stack maintained (see below).

## Offline capabilities this repo provides

This repo is partially designed against cyber-collapse scenarios. What you have here that is useful:

- **Offline Wikipedia, Wikibooks, Wiktionary, Wikivoyage** — Kiwix ZIMs. See [`../../tools-scripts/launch-wikipedia.sh`](../../tools-scripts/launch-wikipedia.sh).
- **Offline medical encyclopedia** (MDWiki) — clinical reference when your usual sources are down.
- **Offline maps** (USGS topo + OSM for west coast) — see [`../../tools-scripts/launch-maps.sh`](../../tools-scripts/launch-maps.sh).
- **Offline Stack Exchange** — technical Q&A when internet is down.
- **Local AI**: Ollama, Gemma 4 via llama.cpp. Ask your own assistant when you can't Google. See [`../../docs/local-ai-models.md`](../../docs/local-ai-models.md).
- **Offline DevDocs** — programmer reference for software engineers trying to keep things running.

In a partial-internet event, these offline resources become disproportionately valuable.

## Specific situations

### Your employer is the victim

- Follow IT guidance strictly.
- Don't "help" by trying to investigate — cyber forensics teams need clean systems.
- Expect work disruption. Document your hours and efforts.
- Personally: ensure your own accounts weren't implicated. Change any reused passwords.

### You work in critical infrastructure

- Have a personal off-duty emergency plan with your family.
- Bunker mentality at work is a real risk; preserve outside relationships.
- Document decisions. Crisis-mode shortcuts become audit nightmares later.

### You have small business impact

- Preserve evidence: timestamps, screenshots, logs of losses.
- Business interruption insurance: check coverage, file early, document.
- Communicate proactively with customers; silence breeds suspicion.
- Consider CISA.gov resources if a US business.

### You were personally breached (not via an infrastructure event)

- Change passwords everywhere you reused them.
- Rotate 2FA on critical accounts (remove old devices, add new).
- If you had a compromised device: wipe and reinstall OS; do not just "clean" it.
- Notify affected institutions (bank, etc.) of suspected compromise.

## What cyber collapse is not

- **It is not the end of civilization.** Every major cyber incident in recent history has been contained within days to weeks. Media narratives to the contrary are selling fear.
- **It is not best responded to with "just unplug everything."** Your accounts still exist, your obligations still exist, your bills still exist. Engagement with the recovery process is the right response.
- **It is not primarily a technical problem for most civilians.** It is an operational problem — cash, patience, backups, alternate channels.

## Before it happens, do this once

The most important preventive preparation is not in this document — it is in [`../tier-1-setup/06-digital-hardening.md`](../tier-1-setup/06-digital-hardening.md). Briefly:

1. Password manager + hardware 2FA keys.
2. 3-2-1 backups.
3. Freeze credit at all three bureaus.
4. Two banks minimum.
5. Cash reserves.
6. Offline copies of critical documents.
7. An out-of-area contact with a separate communication path (phone number they know by heart, not just in your contacts).

Doing those things this weekend makes you materially more resilient to any cyber incident that happens in the future. Almost nothing in the "response" playbook matters as much as doing those prevention items.
