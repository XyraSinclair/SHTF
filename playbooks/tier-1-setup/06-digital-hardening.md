# Digital Hardening

Preventive cyber and digital prep. Most people's biggest "SHTF" exposure isn't nuclear — it's waking up to a drained bank account, a locked email, or a compromised identity during a major incident.

For the reactive playbook (what to do *during* a cyber crisis, grid-partial/internet-down, financial system disruption), see [`../scenarios/07-cyber-collapse.md`](../scenarios/07-cyber-collapse.md). This document is the "before anything happens" layer.

## If you only read one line

**A password manager + hardware 2FA keys + offline backups of critical data will prevent or blunt 95% of personal cyber impact from any real-world incident.** Do those three things, and you are ahead of most targets.

## The threat models

Different scenarios need different prep. Know which you are guarding against:

1. **Opportunistic criminal**: phishing, credential stuffing, SIM swap. High volume, low sophistication. Basic hygiene stops most.
2. **Data breach fallout**: a service you use gets breached, your password and email leak, attackers try them on every other site you use.
3. **Ransomware event personal impact**: you are not the target but your employer is, or a service you depend on (hospital, utility, payment processor) is. You are stuck with no access for days.
4. **Targeted attack**: someone is specifically coming for you (ex, stalker, business rival, adversarial state). Rare but requires different measures.
5. **Infrastructure incident**: major cyber event on banking, power, or telecom. Internet partial or out for extended period. Not about you personally — about operating without your normal digital tools.

Items 1–3 are what most of this doc addresses.

## The essentials (do all of these)

### 1. Password manager — the single highest-ROI item

- Install one: **1Password** (paid, polished), **Bitwarden** (free, open-source, solid), **KeePass / KeePassXC** (fully offline, requires slightly more effort).
- Use a **long, memorable passphrase** as your master password — at least 4 random words (XKCD-style). Do not reuse this anywhere.
- Let the manager generate unique 20+ character passwords for every account. Do not memorize these. That's the point.
- Enable biometric unlock on mobile.
- Import your existing passwords. Change the important ones (email, financial, password manager itself) first.

**Why this matters:** password reuse is how most accounts get compromised, not direct attacks. Kill reuse, kill most of the risk.

### 2. Two-factor authentication (2FA) — everywhere

**Priority order** for enabling 2FA:

1. Your email (email recovery = keys to the kingdom)
2. Your password manager (if cloud-synced)
3. Your phone carrier account (prevents SIM swap)
4. Banking and financial accounts
5. Cloud storage
6. Social accounts (especially if used for login elsewhere)

**Forms of 2FA, best to worst:**

- **Hardware security key** (YubiKey, Google Titan): phishing-resistant. Buy two. Register both on every account. Keep one on you, one backed up at home or in a safe-deposit box. Gold standard. ~$25–55 each.
- **Authenticator app** (Authy, 1Password built-in, Google Authenticator, Aegis on Android): TOTP codes. Good.
- **Push notifications** (bank apps, Microsoft Authenticator): acceptable.
- **SMS 2FA**: better than nothing, but vulnerable to SIM swap. Use only where nothing else is offered.

**Never** use SMS 2FA for your primary email, financial accounts, or phone carrier account. SIM-swap attacks specifically target these.

### 3. Protect your phone number

- Call your carrier. Add a **port-out PIN / port protection / account PIN**. This blocks SIM-swap attacks cold at most carriers.
- Do not use your main phone number as 2FA for financial accounts where app-based 2FA is available.

### 4. Encrypt your devices

- **Laptops**: turn on full-disk encryption. Mac: FileVault. Windows: BitLocker. Linux: LUKS. Requires a password at boot.
- **Phones**: already encrypted on iPhone and modern Android. Set a real passcode (6+ digits, not biometric only). Biometric is convenience; passcode is the actual security.
- **External drives**: encrypt any drive that leaves your home.

### 5. Backups — the 3-2-1 rule

- **3 copies** of anything you can't replace.
- On **2 different media** (hard drive + cloud, or hard drive + another hard drive).
- With **1 offsite** (cloud is offsite; a drive at a friend's house is offsite).

**Tools:**

- Mac: Time Machine to an external drive + iCloud or Backblaze offsite.
- Windows: File History + Backblaze or OneDrive.
- Mixed: Syncthing between your devices and a home NAS.
- Air-gapped: a USB drive you manually sync every month and lock in a safe.

**Encryption matters:** offsite backups should be encrypted at rest. Backblaze, Arq, Restic, Borg all handle this. Unencrypted cloud backups of sensitive data are a leak waiting to happen.

**Test restore at least once.** Most backups are "probably working." Very few are actually working.

## The intermediate layer (do these if item 1–5 are done)

### 6. Email hygiene

- **One primary email** for banking, government, and recovery. Rarely given out.
- **One public email** for shopping, forums, subscriptions. Treated as disposable.
- Consider **email aliases** (Hide My Email on Apple, SimpleLogin, Firefox Relay) for anything that is likely to get spammed or breached.

### 7. Browser and DNS

- Use a mainstream browser with good defaults: Firefox, Safari, Brave, Chrome with strict settings.
- **uBlock Origin** — the single best browser extension for both security and sanity.
- Consider **NextDNS** or **Pi-hole** for DNS-level ad and tracker blocking.
- Private browsing is for privacy from others on your device, not from the network.

### 8. VPN

- A VPN is not a security panacea. It protects against local-network snooping (open WiFi) and some ISP surveillance. It does not make you anonymous.
- If you use one: **Mullvad** or **ProtonVPN** are reputable. Never use a free VPN you haven't vetted — many sell your data.

### 9. Prune your exposure

- Close unused accounts. Every service you signed up for in 2014 is a breach waiting to happen.
- Remove yourself from data-broker sites. DIY or via services like DeleteMe.
- Check **`haveibeenpwned.com`** for your emails. If they show up in recent breaches, change those passwords and rotate anything shared.
- Review app permissions on your phone. Most apps don't need your location, contacts, and microphone.

### 10. Financial resilience

- **Two banks, not one.** If one's fraud system or a cyberattack locks you out, you have the other. Ideally a big-national and a local credit union, so payment rails differ.
- **Freeze your credit** at all three bureaus (Equifax, Experian, TransUnion). Free, online, takes 10 minutes each. Prevents new accounts being opened in your name. Temporarily unfreeze if you need to apply for credit.
- **Enable card-control apps** for your credit cards. One-tap to freeze a card when you notice weird charges.
- **Keep recent paper or PDF bank statements** for 12 months. If online access is disrupted, these are your ledger.

## The advanced layer (optional, scenario-specific)

### 11. Travel / high-risk contexts

- Burner phone and email for border crossings, hostile jurisdictions, or sensitive work.
- Don't carry your primary devices into contexts where they may be seized or compelled. Bring a clean device, log in only to what you need, wipe on return.
- **Travel routers** let you control WiFi on hotel networks.
- Compartmentalize: a separate device for high-risk activity never touches your personal accounts.

### 12. Operational security (OPSEC) for sensitive situations

- Reduce social media posting about location, travel, and household schedule.
- Don't geotag photos of children.
- Don't post pictures of new house keys, boarding passes, or IDs (metadata and visible numbers leak).
- Assume anything on social media is public forever, regardless of privacy settings.

### 13. Preparing for extended internet disruption

Some things only work when the network works. Have offline alternatives:

- **Password manager**: ensure it caches offline (all major ones do, but test by going airplane mode and trying to unlock).
- **Authenticator app**: ensure codes continue to generate offline (they do — TOTP is clock-based, not server-based).
- **Documents**: the encrypted USB approach in [`04-cash-and-documents.md`](04-cash-and-documents.md).
- **Maps**: Organic Maps, downloaded regions. This repo includes offline USGS topo maps and OSM extracts for the PNW — see `maps/` and [`../../tools-scripts/launch-maps.sh`](../../tools-scripts/launch-maps.sh).
- **Reference**: Kiwix + Wikipedia ZIM. This repo includes the full English Wikipedia ZIM — see [`../../tools-scripts/launch-wikipedia.sh`](../../tools-scripts/launch-wikipedia.sh).
- **AI assistant**: Ollama or local Gemma 4 via llama.cpp, for questions when you can't Google. See [`../../docs/local-ai-models.md`](../../docs/local-ai-models.md).
- **Comms**: a ham or GMRS radio with programmed frequencies. See [`../cards/radio-frequencies.md`](../cards/radio-frequencies.md).

## Common mistakes

- **Writing down the master password and losing it.** Write it down, yes. In a specific safe place — your sealed envelope in the safe-deposit box, your estate attorney, your out-of-area contact in a sealed envelope. Not under the keyboard.
- **Using the same 2FA recovery codes across services.** Generate and save per-account.
- **Skipping backups until after a loss.** The backup you didn't make is the one you needed.
- **Believing in perfect security.** All of this is risk reduction, not elimination. Targeted attacks by capable adversaries can still succeed. Your goal is to stop being easy.

## A realistic one-hour setup

If you have one hour right now:

1. Install Bitwarden. Create account with a strong passphrase. (10 min)
2. Turn on 2FA for your primary email using an authenticator app. (10 min)
3. Turn on 2FA for your password manager. (5 min)
4. Call your phone carrier, add a port-out PIN. (10 min)
5. Freeze your credit at all three bureaus. (15 min)
6. Enable full-disk encryption on your laptop if not already on. (10 min, + background time)

You are now materially harder to compromise than most people. Do the rest over the next month.

## Before it happens, do this once

- Calendar reminder: review this checklist annually. Every year something has gotten harder and something has gotten lazier.
- Print the recovery codes for your password manager, primary email, and financial accounts. Store in your encrypted doc stash AND in a sealed envelope somewhere safe.
- If you die or are incapacitated: your spouse / out-of-area contact / attorney needs to be able to access critical accounts. Write an "if I'm not here" letter with enough information for a trusted person to operate. Don't leave your family locked out of your life.
