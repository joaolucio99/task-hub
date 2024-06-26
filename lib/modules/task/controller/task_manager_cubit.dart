import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_hub/core/storage/storage.dart';
import 'package:task_hub/modules/task/models/models.dart';

part 'task_manager_state.dart';

class TaskManagerCubit extends Cubit<TaskManagerState> {
  TaskManagerCubit()
      : super(
          TaskManagerState(
            tasks: const [],
            calendarFilter: DateTime.now(),
          ),
        );

  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController hour = TextEditingController();
  final TextEditingController priority = TextEditingController();

  final _storage = DataStorage();

  Future<void> loadTasks() async {
    final list = <TaskModel>[];

    final result = await _storage.readAll();

    for (final task in result.values) {
      list.add(TaskModel.deserialize(task));
    }

    emit(state.copyWith(tasks: list));
  }

  Future<void> createTask() async {
    final task = TaskModel.create(
      title: title.text,
      description: description.text,
      priority: setPriority(),
      date: convertDate(),
    );

    await _storage.write(task.id, task.serialize());

    emit(
      state.copyWith(
        tasks: [...state.tasks, task],
      ),
    );
  }

  Future<void> editTask() async {
    final newList = state.tasks;
    final index = getIndexByID();

    newList[index] = newList[index].copyWith(
      title: title.text,
      description: description.text,
      priority: setPriority(),
      date: convertDate(),
    );

    await _storage.write(
      state.selectedID,
      newList[index].serialize(),
    );

    emit(state.copyWith(tasks: newList));
  }

  Future<void> deleteTask() async {
    final newList = state.tasks..removeAt(getIndexByID());

    await _storage.delete(state.selectedID);

    emit(state.copyWith(tasks: newList));
  }

  Future<void> endTask() async {
    final newList = state.tasks;
    final index = getIndexByID();

    newList[index] = newList[index].copyWith(
      resolved: true,
      resolvedDate: DateTime.now(),
    );

    await _storage.write(
      state.selectedID,
      newList[index].serialize(),
    );

    emit(state.copyWith(tasks: newList));
  }

  void setCalendarFilter(DateTime date) {
    emit(state.copyWith(calendarFilter: date));
  }

  void setFilter(int filter) {
    emit(state.copyWith(filter: filter));
  }

  int filter(TaskModel a, TaskModel b) {
    switch (state.filter) {
      case 0:
        return a.date.compareTo(b.date);
      case 1:
        return b.date.compareTo(a.date);
      case 2:
        return b.priority.compareTo(a.priority);
      case 3:
        return a.priority.compareTo(b.priority);
      default:
        return a.date.compareTo(b.date);
    }
  }

  void changeTab() {
    late int newValue;

    if (state.tabSelected == 0) {
      newValue = 1;
    } else {
      newValue = 0;
    }

    emit(state.copyWith(tabSelected: newValue));
  }

  int getIndexByID() {
    return state.tasks.indexWhere((element) => element.id == state.selectedID);
  }

  void setSelectedTask(String id) {
    emit(
      state.copyWith(selectedID: id),
    );
  }

  void loadTextEC(TaskModel model) {
    title.text = model.title;
    description.text = model.description;
    date.text = model.date.toString();
    hour.text = model.date.toString();
    priority.text = model.priorityString;

    emit(
      state.copyWith(selectedID: model.id),
    );
  }

  int setPriority() {
    switch (priority.text) {
      case 'Alta':
        return 2;
      case 'Média':
        return 1;
      case 'Baixa':
        return 0;
      default:
        return 1;
    }
  }

  DateTime convertDate() {
    final dateParsed = DateFormat('dd/MM/yyyy').parse(date.text);
    final timeParsed = DateFormat('HH:mm').parse(hour.text);

    return DateTime(
      dateParsed.year,
      dateParsed.month,
      dateParsed.day,
      timeParsed.hour,
      timeParsed.minute,
      timeParsed.second,
      DateTime.now().microsecond,
    );
  }

  void checkButtonState() {
    late bool result;

    if (title.text.isNotEmpty &&
        description.text.isNotEmpty &&
        date.text.isNotEmpty &&
        hour.text.isNotEmpty &&
        priority.text.isNotEmpty) {
      result = false;
    } else {
      result = true;
    }

    emit(state.copyWith(buttonDisabled: result));
  }

  void reset() {
    title.clear();
    description.clear();
    date.clear();
    hour.clear();
    priority.clear();

    emit(
      state.copyWith(
        buttonDisabled: true,
        selectedID: '',
      ),
    );
  }
}
