import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_hub/core/enums/enums.dart';
import 'package:task_hub/core/styles/styles.dart';
import 'package:task_hub/modules/task/controller/task_manager_cubit.dart';
import 'package:task_hub/modules/task/models/models.dart';
import 'package:task_hub/modules/task/view/widgets/task_manager_modal.dart';
import 'package:task_hub/modules/task/view/widgets/task_view_modal.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    super.key,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskManagerCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: EnumPaddings.x1),
      child: GestureDetector(
        onTap: () {
          controller.setSelectedTask(task.id);

          showTaskViewModal(task, context).then((value) => controller.reset());
        },
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.black.withOpacity(0.1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: EnumPaddings.x2Half,
              vertical: EnumPaddings.x1,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                selectIcon(),
                const SizedBox(width: EnumPaddings.x2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: AppTextStyles.subtitle1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.description,
                              style: AppTextStyles.subtitle2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${task.onlyHour} - ${task.onlyDate}',
                              style: AppTextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: EnumPaddings.x2),
                if (task.resolved) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: EnumPaddings.x2,
                      right: EnumPaddings.x1,
                    ),
                    child: SvgPicture.asset(
                      height: 35,
                      'assets/icons/check-mark.svg',
                      colorFilter: ColorFilter.mode(
                        AppColors.black.withOpacity(0.8),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ] else ...[
                  GestureDetector(
                    onTap: () {
                      controller.loadTextEC(task);

                      showTaskManagerModal(context, ManagerModal.edition)
                          .then((value) => controller.reset());
                    },
                    child: SvgPicture.asset(
                      height: 35,
                      'assets/icons/edit.svg',
                      colorFilter: ColorFilter.mode(
                        AppColors.black.withOpacity(0.5),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectIcon() {
    switch (task.priority) {
      case 0:
        return SvgPicture.asset('assets/icons/lowest.svg', height: 40);
      case 1:
        return SvgPicture.asset(
          'assets/icons/medium.svg',
          height: 40,
          colorFilter: ColorFilter.mode(
            task.priorityColor,
            BlendMode.srcIn,
          ),
        );
      case 2:
        return SvgPicture.asset('assets/icons/highest.svg', height: 40);
      default:
        return SvgPicture.asset(
          'assets/icons/medium.svg',
          height: 40,
          colorFilter: ColorFilter.mode(
            task.priorityColor,
            BlendMode.srcIn,
          ),
        );
    }
  }
}
