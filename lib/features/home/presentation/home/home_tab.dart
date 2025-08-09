import 'package:expense_manager/features/home/presentation/home/bloc/home_bloc.dart';
import 'package:expense_manager/features/home/presentation/home/bloc/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

import 'package:expense_manager/features/home/presentation/home/bloc/home_state.dart';

class HomeTab extends BaseStatelessWidget {
  const HomeTab({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return BlocProvider(
      create: (context) => tpGetIt.get<HomeBloc>()..add(const HomeLoadData()),
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeError) {
          return Center(child: Text(state.message));
        } else if (state is HomeLoaded) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Text(state.user.displayName ?? ''),
                  Text(state.user.email ?? ''),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
