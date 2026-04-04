import 'package:daily_driver/screens/inbox_screen.dart';
import 'package:daily_driver/screens/kanban_board.dart';
import 'package:daily_driver/screens/upcoming_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'list_view_screen.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/side_drawer.dart';
import 'settings_screen.dart';

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget screen;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.screen,
  });
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isKanbanView = false;
  int _selectedIndex = 0;

  final bottomNavItems = const <NavItem>[
    NavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
      label: 'Today',
      screen: ListViewScreen(),
    ),
    NavItem(
      icon: Icons.view_kanban_outlined,
      activeIcon: Icons.view_kanban,
      label: 'Kanban',
      screen: KanbanBoard(),
    ),
    NavItem(
      icon: Icons.inbox_outlined,
      activeIcon: Icons.inbox,
      label: 'Inbox',
      screen: InboxScreen(),
    ),

    NavItem(
      icon: Icons.view_agenda_outlined,
      activeIcon: Icons.view_agenda,
      label: 'Upcoming',
      screen: UpcomingScreen(),
    ),
    NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
      screen: SettingsScreen(),
    ),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.read(taskRepositoryProvider).checkRecurringTasks();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width >= 900;

    Widget mainContent = Scaffold(
      appBar: AppBar(
        // elevation: 0,
        // scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(bottomNavItems[_selectedIndex].label),
        automaticallyImplyLeading: !isWideScreen,
        // actions: [
        //   Row(
        //     children: [
        //       Text('List'),
        //       Switch(
        //         value: isKanbanView,
        //         onChanged: (val) {
        //           setState(() {
        //             isKanbanView = val;
        //           });
        //         },
        //       ),
        //       Text('Kanban'),
        //     ],
        //   ),
        //   const SizedBox(width: 8),
        // ],
      ),
      drawer: isWideScreen ? null : const SideDrawer(),
      body: bottomNavItems[_selectedIndex].screen,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final bool isLaterTab =
              _selectedIndex == 2 && ref.read(inboxTabIndexProvider) == 1;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            // backgroundColor: Colors.transparent,
            builder: (context) => AddTaskDialog(initialIsLater: isLaterTab),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: bottomNavItems.map((item) {
          return BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Icon(item.icon),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Icon(item.activeIcon),
            ),
            label: item.label,
          );
        }).toList(),
      ),
    );

    if (isWideScreen) {
      final double screenWidth = MediaQuery.of(context).size.width;
      final double sideDrawerWidth = (screenWidth * 0.18).clamp(250.0, 350.0);
      return Scaffold(
        body: Row(
          children: [
            SideDrawer(permanent: true, width: sideDrawerWidth),
            Expanded(child: mainContent),
          ],
        ),
      );
    }

    return mainContent;
  }
}
