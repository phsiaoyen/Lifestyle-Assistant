import 'package:flutter/material.dart';
import 'package:test_dart/models/alarm.dart';

class NewAlarm extends StatefulWidget {
  const NewAlarm({required this.onAddAlarm, super.key});

  final void Function(Alarm alarm) onAddAlarm;

  @override
  State<NewAlarm> createState() {
    return _NewAlarmState();
  }
}

class _NewAlarmState extends State<NewAlarm> {
  final _titleController = TextEditingController();
  // final List<TimeOfDay?> _selectedTimes = [null, null, null, null, null, null, null];
  final _selectedTimes = List<TimeOfDay?>.filled(7, null);

  GlobalKey titleKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _titleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

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

  void _presentTimePicker(int i) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) {
      return;
    }
    setState(() {
      _selectedTimes[i] = pickedTime;
    });
  }

  void _submitScheduleData() {
    bool invalid = true;
    for(int i = 0; i < 7; i++) {
      if(_selectedTimes[i] != null) {
        invalid = false;
        break;
      }
    }

    if (_titleController.text.trim().isEmpty || invalid) {
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

    widget.onAddAlarm(
      Alarm(
        title: _titleController.text,
        times: _selectedTimes,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    //return LayoutBuilder(builder: (ctx, constraints) {

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            //padding: EdgeInsets.fromLTRB(16, 160, 16, keyboardSpace + 16),
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            child: Column(
              children: [
                TextField(
                  key: titleKey,
                  controller: _titleController,
                  maxLength: 50,
                  focusNode: _titleFocusNode,
                  decoration: const InputDecoration(
                    label: Text('Default Alarm'),
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
                          const Text('Sunday'),
                          const SizedBox(width: 16),
                          Text(
                            _selectedTimes[0] == null
                                ? 'No time selected'
                                : _selectedTimes[0]!.format(context),
                          ),
                          IconButton(
                            onPressed: () => _presentTimePicker(0),
                            icon: const Icon(
                              Icons.alarm,
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
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Monday'),
                          const SizedBox(width: 16),
                          Text(
                            _selectedTimes[1] == null
                                ? 'No time selected'
                                : _selectedTimes[1]!.format(context),
                          ),
                          IconButton(
                            onPressed: () => _presentTimePicker(1),
                            icon: const Icon(
                              Icons.alarm,
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
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Tuesday'),
                          const SizedBox(width: 16),
                          Text(
                            _selectedTimes[2] == null
                                ? 'No time selected'
                                : _selectedTimes[2]!.format(context),
                          ),
                          IconButton(
                            onPressed: () => _presentTimePicker(2),
                            icon: const Icon(
                              Icons.alarm,
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
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Wednesday'),
                          const SizedBox(width: 16),
                          Text(
                            _selectedTimes[3] == null
                                ? 'No time selected'
                                : _selectedTimes[3]!.format(context),
                          ),
                          IconButton(
                            onPressed: () => _presentTimePicker(3),
                            icon: const Icon(
                              Icons.alarm,
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
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Thursday'),
                          const SizedBox(width: 16),
                          Text(
                            _selectedTimes[4] == null
                                ? 'No time selected'
                                : _selectedTimes[4]!.format(context),
                          ),
                          IconButton(
                            onPressed: () => _presentTimePicker(4),
                            icon: const Icon(
                              Icons.alarm,
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
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Friday'),
                          const SizedBox(width: 16),
                          Text(
                            _selectedTimes[5] == null
                                ? 'No time selected'
                                : _selectedTimes[5]!.format(context),
                          ),
                          IconButton(
                            onPressed: () => _presentTimePicker(5),
                            icon: const Icon(
                              Icons.alarm,
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
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Saturday'),
                          const SizedBox(width: 16),
                          Text(
                            _selectedTimes[6] == null
                                ? 'No time selected'
                                : _selectedTimes[6]!.format(context),
                          ),
                          IconButton(
                            onPressed: () => _presentTimePicker(6),
                            icon: const Icon(
                              Icons.alarm,
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
                      child: const Text('Save Alarm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    //});
  }
}
