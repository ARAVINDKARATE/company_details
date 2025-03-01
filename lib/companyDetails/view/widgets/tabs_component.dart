import 'package:flutter/material.dart';

class TabsComponent extends StatefulWidget {
  final int initialIndex;
  final Function(int) onTabChanged;

  const TabsComponent({
    super.key,
    this.initialIndex = 0,
    required this.onTabChanged,
  });

  @override
  _TabsComponentState createState() => _TabsComponentState();
}

class _TabsComponentState extends State<TabsComponent> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 42,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTab("ISIN Analysis", 0),
          SizedBox(width: 24),
          _buildTab("Pros & Cons", 1),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        widget.onTabChanged(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Color(0xFF1447E6) : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color:
                isSelected
                    ? Color(0xFF1447E6)
                    : Color(0xFF4A5565).withOpacity(0.9),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
