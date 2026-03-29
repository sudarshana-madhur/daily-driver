import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF141311),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF263c46,
                        ), // A muted blue-grey for the placeholder avatar background
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFe2e6e2),
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alex Editor',
                          // style: TextStyle(
                          //   // color: Colors.white,
                          //   fontWeight: FontWeight.bold,
                          //   fontSize: 18,
                          // ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'EDITORIAL TASKMASTER',
                          // style: TextStyle(
                          //   // color: Colors.white.withOpacity(0.5),
                          //   fontSize: 10,
                          //   fontWeight: FontWeight.w800,
                          //   letterSpacing: 1.0,
                          // ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildMenuItem(context, Icons.inbox, 'Inbox', false),
              _buildMenuItem(context, Icons.calendar_today, 'Today', true),
              _buildMenuItem(context, Icons.calendar_month, 'Upcoming', false),
              _buildMenuItem(
                context,
                Icons.format_list_bulleted,
                'Projects',
                false,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'YOUR PROJECTS',
                      // style: TextStyle(
                      //   // color: Colors.white.withOpacity(0.5),
                      //   fontSize: 10,
                      //   fontWeight: FontWeight.w800,
                      //   letterSpacing: 1.0,
                      // ),
                    ),
                    Icon(
                      Icons.add,
                      // color: Colors.white.withOpacity(0.5),
                      size: 16,
                    ),
                  ],
                ),
              ),
              _buildProjectItem(context, 'Work', const Color(0xFF3b82f6)),
              _buildProjectItem(context, 'Personal', const Color(0xFFf97316)),
              _buildProjectItem(context, 'Fitness', const Color(0xFF10b981)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    bool isSelected,
  ) {
    // final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(
          // color: isSelected ? const Color(0xFF2D2926) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          horizontalTitleGap: 8,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          leading: Icon(
            icon,
            // color: primaryColor,
            size: 24,
          ),
          title: Text(
            title,
            // style: TextStyle(
            //   // color: Colors.white,
            //   fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            //   fontSize: 16,
            // ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildProjectItem(BuildContext context, String title, Color dotColor) {
    return ListTile(
      horizontalTitleGap: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
        ],
      ),
      title: Text(
        title,
        // style: const TextStyle(
        //   color: Color(0xFFD4D4D4),
        //   fontSize: 16,
        //   fontWeight: FontWeight.w500,
        // ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
    );
  }
}
