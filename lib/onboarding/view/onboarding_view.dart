import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jambu/onboarding/bloc/onboarding_bloc.dart';
import 'package:jambu/onboarding/widgets/widgets.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.status == OnboardingStatus.completed) {
          context.pushReplacement('/');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        OnboardingContainer(
                          child: WelcomeOnboarding(
                            onConfirmTap: () => _pageController.nextPage(
                              duration: PageTransition.duration,
                              curve: PageTransition.curve,
                            ),
                          ),
                        ),
                        OnboardingContainer(
                          child: RegularAttendancesOnboarding(
                            weekdays: state.regularWeekdays,
                            onDayTap: (weekdays) {
                              context.read<OnboardingBloc>().add(
                                    OnboardingUpdateAttendances(
                                      weekdays: weekdays,
                                    ),
                                  );
                            },
                            onBackTap: () {
                              _pageController.previousPage(
                                duration: PageTransition.duration,
                                curve: PageTransition.curve,
                              );
                            },
                            onConfirmTap: () => _pageController.nextPage(
                              duration: PageTransition.duration,
                              curve: PageTransition.curve,
                            ),
                          ),
                        ),
                        OnboardingContainer(
                          child: NotificationsOnboarding(
                            isLoading: state.status ==
                                OnboardingStatus.notificationsRequested,
                            onConfirmTap: () => context
                                .read<OnboardingBloc>()
                                .add(OnboardingRequestNotifications()),
                            onDeclineTap: () => context
                                .read<OnboardingBloc>()
                                .add(OnboardingCompleted()),
                            onBackTap: () {
                              _pageController.previousPage(
                                duration: PageTransition.duration,
                                curve: PageTransition.curve,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
