import 'package:daily_driver/screens/later_screen.dart';
import 'package:daily_driver/screens/todo_screen.dart';
import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Column(
        children: [
          // 2. The TabBar embedded in the layout
          TabBar(
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
              children: [
                Center(child: TodoScreen()),
                Center(child: LaterScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
