// docs/architecture/responsive_strategy.md

# Responsive UI Strategy

## Breakpoint Philosophy
| Category | Width range (dp) | Description |
|----------|-----------------|-------------|
| **compact** | `< 600` | Typical phones. UI stays single‑column, bottom navigation preserved. |
| **medium** | `≥ 600 && < 1024` | Tablets and large phones. UI may expand to two‑column layouts; navigation can use a spaced bottom bar or a modest side rail. |
| **expanded** | `≥ 1024` | Desktops, large tablets, web browsers. UI adopts side navigation rail, wider content containers, multi‑column grids. |

## Architecture
- New package `lib/core/responsive/` containing:
  - `responsive_breakpoints.dart` – constant breakpoint values.
  - `responsive_utils.dart` – `ResponsiveScreenSize` enum and helper `getScreenSize`.
- `SideNavigation` widget (placeholder) imported in `MainScaffold` for future desktop navigation.
- All existing screens should query `ResponsiveScreenSize` via `getScreenSize(context)` and adapt layout accordingly (e.g., using `LayoutBuilder`, `Flex`, `GridView`).

## Navigation Adaptation
- **Compact**: Keep existing `BottomNavigationBar` (already present). No change.
- **Medium**: Bottom bar gets extra padding; optional side rail can be toggled on larger tablets.
- **Expanded**: Use `SideNavigation` (rail) on the left, keeping the same 7 destinations. Bottom bar is hidden on desktop/web.

## Content Layout Adjustments
- Each feature screen (`Home`, `Explore`, `Stories`, `Quests`, `Profile`, `Settings`, `Sky`) should wrap its body in a `ConstrainedBox` with a max width of **1200dp** for expanded screens to avoid overstretching.
- Use `Flexible`, `Expanded`, `Wrap`, and `GridView` to let children reflow.
- Text sizes remain defined by the theme; only container constraints change.

## Accessibility Considerations
- Touch target minimum 48dp retained for mobile.
- Hover effects added for desktop via `InkWell` (already present in navigation items).
- All colors keep the original contrast ratios; no new colors introduced.

## Documentation
- This file documents the responsive approach.
- Updated `docs/architecture/domain_models.md` references the new responsive section.
