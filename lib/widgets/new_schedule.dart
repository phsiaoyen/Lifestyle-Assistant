import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_dart/models/schedule.dart';

final formatter = DateFormat.yMd().add_Hm();

class NewSchedule extends StatefulWidget {
  const NewSchedule({required this.currentDate, required this.onAddSchedule, super.key});

  final DateTime currentDate;
  final void Function(Schedule schedule) onAddSchedule;

  @override
  State<NewSchedule> createState() {
    return _NewScheduleState();
  }
}

class _NewScheduleState extends State<NewSchedule> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  DateTime? _current;

  GlobalKey titleKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _titleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _current = widget.currentDate;

    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        final RenderBox renderBox =
            titleKey.currentContext?.findRenderObject() as RenderBox;
        _scrollToRenderBox(renderBox);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scrollController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _scrollToRenderBox(RenderBox renderBox) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bottomPosition = offset.dy + renderBox.size.height;
    final visibleScreenHeight = screenHeight - keyboardHeight;

    if (bottomPosition > visibleScreenHeight) {
      final scrollOffset = bottomPosition - visibleScreenHeight + 16;
      _scrollController.animateTo(
        _scrollController.offset + scrollOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _presentDatePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(
        _current!.year,
        _current!.month,
        _current!.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _submitScheduleData() {
    if (_titleController.text.trim().isEmpty ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, date was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddSchedule(
      Schedule(
        title: _titleController.text,
        date: _selectedDate!,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 160, 16, keyboardSpace + 16),
            child: Column(
              children: [
                TextField(
                  key: titleKey,
                  controller: _titleController,
                  maxLength: 50,
                  focusNode: _titleFocusNode,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'No time selected'
                                : formatter.format(_selectedDate!),
                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(
                              Icons.schedule,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitScheduleData,
                      child: const Text('Save Schedule'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
