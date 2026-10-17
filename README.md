# Qwiko

**Everything Delivered Instantly**

Premium multi-vendor on-demand delivery UI prototype built with Flutter, GetX, and Material 3.

## Run

```bash
flutter pub get
flutter run
```

## Architecture

- **GetX** — navigation, reactive state, controllers
- **Feature-first** — screens under `lib/features/`
- **Clean layers** — `core/`, `models/`, `data/`, `controllers/`, `routes/`
- **UI only** — mock JSON data, no backend / Firebase / payments

## Features

| Tab / Flow | Screens |
|---|---|
| Home | Banners, categories, vendors, deals, flash sale, products |
| Categories | Grid + category detail (filters, vendors, products) |
| Search | Recent/popular, suggestions, trending |
| Cart → Checkout | Vendor grouping, coupons, wallet, place order |
| Profile | Wallet, orders, wishlist, addresses, offers, settings, help |

Also: store detail, product detail, order tracking, notifications, referrals.

## Theme

| Token | Value |
|---|---|
| Primary | `#6BE785` (accents, indicators, gradients) |
| Primary Dark / CTA | `#42C86B` (solid buttons + white text) |
| Secondary | `#2F6F4F` |
| Accent | `#1E293B` |
| Background | `#F7F9F8` |
| Price | `#16A34A` |

Dark theme tokens and full WCAG-minded contrast rules live in `lib/core/theme/app_colors.dart`.

## Structure

```
lib/
  core/          theme, widgets, utils
  models/        data models
  data/          mock_data.dart
  controllers/   cart, wishlist, main tab
  routes/        GetX pages
  features/      splash, home, categories, search, store,
                 product, cart, checkout, orders, tracking,
                 wallet, offers, notifications, profile,
                 settings, help, address
  main.dart
```
