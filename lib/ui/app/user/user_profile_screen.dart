import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:topix/data/models/user.dart';
import 'package:topix/ui/app/layout.dart';
import 'package:topix/ui/app/user/user_profile_view_model.dart';
import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/toast.dart';
import 'package:topix/utils/extensions.dart' show ThemeHelper;

class UserProfileScreen extends StatefulWidget {
  final UserProfileViewModel viewModel;

  const UserProfileScreen({super.key, required this.viewModel});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 3, vsync: this);
  int profileTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabController.addListener(() {
        if (tabController.index != tabController.previousIndex) {
          profileTabIndex = tabController.index;
        }
      });
      widget.viewModel.loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    final self = context.read<UserModel>();

    return AppLayout(
      child: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          return Column(
            children: [
              // user info
              Container(
                color: context.colorScheme.surfaceContainer,
                padding: const .only(top: 12, left: 12, right: 12, bottom: 6),
                child: vm.loadingUser
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : Column(
                  spacing: 8,
                        children: [
                          Row(
                            spacing: 16,
                            children: [
                              SizedBox.square(
                                dimension: 80,
                                child: ClipOval(child: vm.user.profileImage),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 8,
                                      children: [
                                        Text(
                                          vm.user.displayName,
                                          style: TextStyle(
                                            color: context.colorScheme.onSurface,
                                            fontSize: FontSize.mediumSmall,
                                            fontWeight: .w700,
                                          ),
                                        ),
                                        Text(
                                          '@${vm.user.username}',
                                          style: TextStyle(
                                            color: context.colorScheme.onSurfaceVariant,
                                            fontSize: FontSize.small,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      vm.user.description ?? '',
                                      style: TextStyle(
                                        color: context.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 8,
                            children: [
                              Text(
                                'Following: ${vm.user.followingCount}',
                                style: TextStyle(color: context.colorScheme.onSurface),
                              ),
                              Text(
                                'Follower: ${vm.user.followerCount}',
                                style: TextStyle(color: context.colorScheme.onSurface),
                              ),
                              const Spacer(),
                              if (self.id != vm.user.id) ...[
                                Button(
                                  tooltip: 'Message',
                                  type: .base,
                                  icon: Icon(Icons.chat_bubble_rounded,size: 20,),
                                  onPressed: () {
                                    context.showToast('Feature is not yet implemented.');
                                  },
                                ),
                                Button(
                                  tooltip: vm.user.followed == true
                                      ? 'Unfollow'
                                      : 'Follow',
                                  type: vm.user.followed == true ? .danger : .base,
                                  icon: Icon(
                                    vm.user.followed == true
                                        ? Icons.person_remove_rounded
                                        : Icons.person_add_alt_rounded,size: 20,
                                  ),
                                  onPressed: () {
                                    context.showToast('Feature is not yet implemented.');
                                  },
                                ),
                              ] else
                                Button(
                                  tooltip: 'Options',
                                  icon: Icon(Icons.menu_rounded),
                                  onPressed: () {
                                    context.showToast('Feature is not yet implemented.');
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
