import 'package:flutter/material.dart';

/// Qwiko Design System — color tokens
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────
  static const Color primary = Color(0xFF6BE785);
  static const Color primaryDark = Color(0xFF42C86B);
  static const Color primaryLight = Color(0xFFDDF9E5);
  static const Color primaryContainer = Color(0xFFC8F5D4);
  static const Color secondary = Color(0xFF2F6F4F);
  static const Color secondaryLight = Color(0xFFE8F7ED);
  static const Color accent = Color(0xFF1E293B);

  // ── Semantic ───────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Light surfaces ─────────────────────────────────
  static const Color background = Color(0xFFF7F9F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F2);
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD9E2DD);

  // ── Light text ─────────────────────────────────────
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);
  static const Color heading = Color(0xFF111827);
  static const Color body = Color(0xFF374151);
  static const Color caption = Color(0xFF6B7280);

  // ── Dark theme ─────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF263547);
  static const Color darkCard = Color(0xFF1F2937);
  static const Color darkDivider = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF475569);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextHint = Color(0xFF94A3B8);
  static const Color darkDisabled = Color(0xFF64748B);

  // ── Buttons ────────────────────────────────────────
  static const Color buttonPrimary = Color(0xFF42C86B);
  static const Color buttonPrimaryText = Color(0xFFFFFFFF);
  static const Color buttonHover = Color(0xFF36B45D);
  static const Color buttonPressed = Color(0xFF2E9F52);
  static const Color buttonDisabled = Color(0xFFA7E8BA);
  static const Color buttonSecondaryBg = Color(0xFFFFFFFF);
  static const Color buttonSecondaryBorder = Color(0xFF42C86B);
  static const Color buttonSecondaryText = Color(0xFF2F6F4F);

  // ── Navigation ─────────────────────────────────────
  static const Color navSelectedIcon = Color(0xFF42C86B);
  static const Color navSelectedLabel = Color(0xFF2F6F4F);
  static const Color navUnselected = Color(0xFF94A3B8);
  static const Color navBackground = Color(0xFFFFFFFF);

  // ── App bar ────────────────────────────────────────
  static const Color appBarBackground = Color(0xFFFFFFFF);
  static const Color appBarTitle = Color(0xFF111827);
  static const Color appBarIcon = Color(0xFF374151);

  // ── Search ─────────────────────────────────────────
  static const Color searchBackground = Color(0xFFF3F4F6);
  static const Color searchHint = Color(0xFF9CA3AF);
  static const Color searchText = Color(0xFF111827);
  static const Color searchIcon = Color(0xFF6B7280);

  // ── Product card ───────────────────────────────────
  static const Color price = Color(0xFF16A34A);
  static const Color oldPrice = Color(0xFF9CA3AF);
  static const Color discountBadge = Color(0xFFEF4444);
  static const Color rating = Color(0xFFFBBF24);
  static const Color cardShadow = Color(0xFFE5E7EB);

  // ── Badges ─────────────────────────────────────────
  static const Color badgeNew = Color(0xFF22C55E);
  static const Color badgeHot = Color(0xFFEF4444);
  static const Color badgeSale = Color(0xFFF97316);
  static const Color badgeOutOfStock = Color(0xFF64748B);

  // ── Order status ───────────────────────────────────
  static const Color statusAvailable = Color(0xFF16A34A);
  static const Color statusPreparing = Color(0xFF3B82F6);
  static const Color statusOnTheWay = Color(0xFFF59E0B);
  static const Color statusDelivered = Color(0xFF22C55E);
  static const Color statusCancelled = Color(0xFFEF4444);

  // ── Misc ───────────────────────────────────────────
  static const Color overlay = Color(0x80000000);
  static const Color shimmerBase = Color(0xFFE8E8E8);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color errorText = Color(0xFFDC2626);

  // ── Gradients ──────────────────────────────────────
  static const List<Color> primaryGradient = [
    Color(0xFF6BE785),
    Color(0xFF42C86B),
  ];
  static const List<Color> heroGradient = [
    Color(0xFF6BE785),
    Color(0xFFA5F3C2),
  ];
  static const List<Color> darkHeroGradient = [
    Color(0xFF42C86B),
    Color(0xFF2F6F4F),
  ];

  static const List<Color> categoryGradients = [
    Color(0xFFDDF9E5),
    Color(0xFFFFF0E6),
    Color(0xFFE8F4FF),
    Color(0xFFFFE8F0),
    Color(0xFFF3E8FF),
    Color(0xFFFFF8E8),
    Color(0xFFE8F7ED),
    Color(0xFFFFE8E8),
  ];
}
