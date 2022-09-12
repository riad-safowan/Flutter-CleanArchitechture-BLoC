import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Number Trivia')),
        body: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
          child: Column(
            children: [
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaInitial) {
                    return const MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is NumberTriviaLoading) {
                    return const LoadingWidget();
                  } else if (state is NumberTriviaLoaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is NumberTriviaError) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return const MessageDisplay(
                      message: 'Something went wrong!',
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
                const TriviaControls()
            ],
          ),
        ));
  }
}
