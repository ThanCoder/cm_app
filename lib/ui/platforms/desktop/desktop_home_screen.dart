import 'package:cm_app/ui/platforms/pages/more_page.dart';
import 'package:cm_app/ui/platforms/desktop/desktop_home_page.dart';
import 'package:flutter/material.dart';

class DesktopHomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            selectedIndex: selectedIndex,
            onSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: [
                DesktopHomePage(),
                Placeholder(),
                Placeholder(),
                Placeholder(),
                Placeholder(),
                MorePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SIDEBAR
// ============================================================

final class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 235,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        border: Border(right: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(
                  Icons.movie_creation_rounded,
                  size: 30,
                  color: scheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  'TVP',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 35),

          _SidebarItem(
            icon: Icons.home_rounded,
            title: 'Home',
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),

          _SidebarItem(
            icon: Icons.movie_rounded,
            title: 'Movies',
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),

          _SidebarItem(
            icon: Icons.tv_rounded,
            title: 'TV Shows',
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),

          _SidebarItem(
            icon: Icons.favorite_rounded,
            title: 'Favorites',
            selected: selectedIndex == 3,
            onTap: () => onSelected(3),
          ),

          _SidebarItem(
            icon: Icons.history_rounded,
            title: 'History',
            selected: selectedIndex == 4,
            onTap: () => onSelected(4),
          ),

          const Spacer(),

          _SidebarItem(
            icon: Icons.settings_rounded,
            title: 'Settings',
            selected: selectedIndex == 5,
            onTap: () => onSelected(5),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

final class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: selected ? scheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: selected
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    color: selected
                        ? scheme.onPrimaryContainer
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
