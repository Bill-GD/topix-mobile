import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:topix/data/models/user.dart';
import 'package:topix/ui/app/layout.dart';
import 'package:topix/ui/app/user/user_profile_view_model.dart';
import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/post/post.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      tabController.addListener(() {
        if (tabController.index != tabController.previousIndex) {
          profileTabIndex = tabController.index;
        }
      });
      await widget.viewModel.loadUser();
      widget.viewModel.loadPosts(context.read<UserModel>().id);
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
          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              final pixels = notification.metrics.pixels,
                  maxScrollExtent = notification.metrics.maxScrollExtent;
              if (maxScrollExtent - pixels <= 50) {
                switch (profileTabIndex) {
                  case 0:
                    vm.loadPosts(self.id);
                  case 1:
                  case 2:
                }
              }
              return true;
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // user info
                SliverToBoxAdapter(
                  child: Container(
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
                                                color:
                                                    context.colorScheme.onSurfaceVariant,
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
                                    style: TextStyle(
                                      color: context.colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'Follower: ${vm.user.followerCount}',
                                    style: TextStyle(
                                      color: context.colorScheme.onSurface,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (self.id != vm.user.id) ...[
                                    Button(
                                      tooltip: 'Message',
                                      type: .base,
                                      icon: Icon(Icons.chat_bubble_rounded, size: 20),
                                      onPressed: () {
                                        context.showToast(
                                          'Feature is not yet implemented.',
                                        );
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
                                            : Icons.person_add_alt_rounded,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        context.showToast(
                                          'Feature is not yet implemented.',
                                        );
                                      },
                                    ),
                                  ] else
                                    Button(
                                      tooltip: 'Options',
                                      icon: Icon(Icons.menu_rounded),
                                      onPressed: () {
                                        context.showToast(
                                          'Feature is not yet implemented.',
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      controller: tabController,
                      enableFeedback: false,
                      splashFactory: NoSplash.splashFactory,
                      indicatorSize: .label,
                      indicator: UnderlineTabIndicator(
                        borderRadius: .circular(10),
                        insets: const .symmetric(vertical: 6),
                        borderSide: BorderSide(
                          width: 3,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      labelStyle: const TextStyle(fontWeight: .bold),
                      unselectedLabelStyle: const TextStyle(fontWeight: .w500),
                      tabs: [
                        Tab(text: 'Posts'),
                        Tab(text: 'Threads'),
                        Tab(text: 'Groups'),
                      ],
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                controller: tabController,
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (vm.loadingPosts && index == vm.posts.length) {
                            return Center(child: CircularProgressIndicator.adaptive());
                          }

                          return Post(
                            self: self,
                            post: vm.posts.elementAt(index),
                            reactPost: vm.reactPost,
                            deletePost: vm.removePost,
                          );
                        }, childCount: vm.posts.length + (vm.loadingPosts ? 1 : 0)),
                      ),
                    ],
                  ),
                  Text('Thread list not yet implemented', textAlign: .center),
                  Text('Group list not yet implemented', textAlign: .center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Theme.of(context).scaffoldBackgroundColor, child: tabBar);
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}
