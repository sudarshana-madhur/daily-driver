import 'package:daily_driver/screens/later_screen.dart';
import 'package:daily_driver/screens/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxTabIndex extends Notifier<int> {
  @override
  int build() => 0;
  void set(int index) => state = index;
}

final inboxTabIndexProvider = NotifierProvider<InboxTabIndex, int>(
  InboxTabIndex.new,
);

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(inboxTabIndexProvider.notifier).set(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 2. The TabBar embedded in the layout
        TabBar(
          controller: _tabController,
          labelStyle: Theme.of(context).textTheme.labelSmall,
          indicatorSize: TabBarIndicatorSize.tab,
          // labelColor: Colors.black,
          tabs: [
            Tab(
              // icon: Icon(Icons.list, size: tabText?.fontSize),
              text: "TO-DO",
            ),
            Tab(
              // icon: Icon(Icons.timer, size: tabText?.fontSize),
              text: "LATER",
            ),
          ],
        ),

        // 3. The TabBarView (Must be inside Expanded to fill remaining space)
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Center(child: TodoScreen()),
              Center(child: LaterScreen()),
            ],
          ),
        ),
      ],
    );
  }
}
