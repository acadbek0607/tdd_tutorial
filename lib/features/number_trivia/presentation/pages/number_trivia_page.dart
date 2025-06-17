import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_tutorial/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:tdd_tutorial/injection_container.dart';

import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Number Trivia',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      // Top half
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return Center(
                      child: MessageDisplay(message: "Start seaching!"),
                    );
                  } else if (state is Loading) {
                    return Center(child: LoadingWidget());
                  } else if (state is Loaded) {
                    return Center(
                      child: TriviaDisplay(numberTrivia: state.trivia),
                    );
                  } else if (state is Error) {
                    return Center(
                      child: MessageDisplay(message: state.message),
                    );
                  }
                  // Add a default widget for other states
                  return SizedBox.shrink();
                },
              ),
              SizedBox(height: 20),
              // Bottom half
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
