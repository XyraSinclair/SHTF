# Radio Frequencies Card

Emergency, weather, and amateur frequencies. US West Coast focus.

## NOAA Weather Radio (all US)

Continuous weather broadcasts; emergency activation for tornadoes, floods, earthquakes, tsunamis, and civil emergencies.

| Channel | Frequency (MHz) |
|---------|-----------------|
| WX1 | 162.400 |
| WX2 | 162.425 |
| WX3 | 162.450 |
| WX4 | 162.475 |
| WX5 | 162.500 |
| WX6 | 162.525 |
| WX7 | 162.550 |

Any NOAA-capable radio receives these. Choose strongest nearby station.

## Emergency radio calling frequencies

| Band | Frequency | Notes |
|------|-----------|-------|
| 2 m ham | **146.520 MHz** | National 2m FM simplex calling freq |
| 70 cm ham | **446.000 MHz** | National 70cm FM simplex calling freq |
| Marine | **VHF Channel 16 (156.800 MHz)** | Distress and calling, worldwide |
| Marine | **VHF Channel 22A** | USCG working after 16 contact |
| GMRS / FRS | **Channel 1 (462.5625 MHz)** | Common family radio monitoring |
| GMRS | **Channel 20 (462.6750 MHz)** | Travel channel, emergencies |
| MURS | **151.820 / 151.880 / 151.940 / 154.570 / 154.600 MHz** | No license; ~2W |
| CB | **Channel 9 (27.065 MHz)** | Emergency / motorist assistance |
| CB | **Channel 19 (27.185 MHz)** | Trucker channel |

## AM broadcast (long-range)

- **AM 1610 kHz** — Highway Advisory / emergency info (some regions)
- **AM 530 kHz** — Travelers' Information Station (varies by region)

Local commercial AM stations carry Emergency Alert System (EAS) messages.

## US West Coast regional ARES / emergency nets (ham)

*Verify locally — frequencies and schedules change. These are starting points.*

### Washington State

- **W7AW Puget Sound Mt. Constitution (Orcas Is.)** 146.800 MHz −600 kHz offset, tone varies
- **WA7LAW Everett** 147.360 MHz +600 kHz offset, tone 103.5
- **W7AW Tiger Mtn** 146.820 MHz −600 kHz offset, tone 103.5

### Oregon

- **W7ODX Portland** 146.840 MHz −600 kHz offset, tone 107.2
- **Oregon ARES/RACES net**: check regional freqs via `oregonares.org`

### Northern California

- **K6FED Loma Prieta** 146.115 MHz +600 kHz offset, tone 100.0
- **San Francisco Bay Area ARES**: `ares-bayarea.org` for local nets

See `radio/NOAA_Weather_Radio_Frequencies_West_Coast.txt` for station-specific NOAA details.

## FRS / GMRS channels (family radio)

FRS: no license, 0.5–2W typical consumer handhelds.

GMRS: requires $35 FCC license (no test, covers family), up to 50W mobile, repeaters allowed.

Both share 22 common channels:

| Ch | Freq (MHz) | Notes |
|----|------------|-------|
| 1  | 462.5625 | FRS/GMRS |
| 2  | 462.5875 | FRS/GMRS |
| 3  | 462.6125 | FRS/GMRS |
| 4  | 462.6375 | FRS/GMRS |
| 5  | 462.6625 | FRS/GMRS |
| 6  | 462.6875 | FRS/GMRS |
| 7  | 462.7125 | FRS/GMRS |
| 8–14 | 467.xxx | FRS low-power only |
| 15–22 | 462.xxx | GMRS full-power |

## Baofeng UV-5R default emergency programming

*Suggested bank — program before you need it.*

| Memory | Frequency | Mode | Purpose |
|--------|-----------|------|---------|
| 1 | 146.520 MHz | FM | 2m calling |
| 2 | 446.000 MHz | FM | 70cm calling |
| 3 | 162.550 MHz | FM | NOAA WX |
| 4 | 162.450 MHz | FM | NOAA WX |
| 5 | 156.800 MHz | FM | Marine Ch 16 |
| 6 | 462.5625 MHz | FM | GMRS Ch 1 |
| 7 | 462.6750 MHz | FM | GMRS Ch 20 (travel) |
| 8 | Local repeater | FM | Add your area's active repeater |
| 9 | Local repeater | FM | Backup repeater |
| 10 | 151.820 MHz | FM | MURS Ch 1 |

See `radio/UV-5R_Programming_Cheat_Sheet.pdf` and `radio/Baofeng_UV-5R_Programming_Guide.pdf`.

## Operating rules (practical)

- **Listen before transmit.** Don't step on active traffic.
- **Identify**: ham operators must identify with callsign every 10 min and at end of transmission.
- **Emergency**: Mayday (marine/aviation), "emergency traffic" on ham.
- **Duty cycle**: Baofengs are low-cost and will overheat with long transmissions. Short presses.
- **Transmit responsibly**: transmitting on frequencies requiring license without one is a federal offense (though enforcement is rare in genuine emergencies).

## Distress

- **Voice**: "Mayday, mayday, mayday" (marine/aviation) or "Break, break, emergency traffic" (ham).
- **State**: your identity, location, situation, persons involved, assistance needed.
- **Morse SOS**: `... --- ...` works on any signal medium (flashlight, whistle, tap).

## Before you need it, do this once

1. Get a radio (Baofeng UV-5R works, ~$25).
2. Get a programming cable (~$10).
3. Program this card's frequencies into it.
4. Write down your local active repeaters from `repeaterbook.com` while you have internet.
5. If serious about ham: get your Technician license (one test, ~$15, opens full legal use of 2m/70cm).

---

*Sources: `radio/UV-5R_Quick_Reference_Card.pdf`, `radio/ARRL_ARES_Field_Resources_Manual.pdf`, `radio/NOAA_Weather_Radio_Frequencies_West_Coast.txt`, FCC FRS/GMRS regulations.*
