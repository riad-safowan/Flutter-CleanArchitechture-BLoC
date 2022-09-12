import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Number Trivia')),
        body: Column(
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
        ));
  }
}

//   BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
//     return BlocProvider(
//       create: (_) => sl<NumberTriviaBloc>(),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: 10),
//               // Top half
//               BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
//                 builder: (context, state) {
//                   // if (state is NumberTriviaInitial) {
//                   //   return MessageDisplay(
//                   //     message: 'Start searching!',
//                   //   );
//                   // } else if (state is Loading) {
//                   //   return LoadingWidget();
//                   // } else if (state is Loaded) {
//                   //   return TriviaDisplay(numberTrivia: state.trivia);
//                   // } else if (state is Error) {
//                   //   return MessageDisplay(
//                   //     message: state.message,
//                   //   );
//                   // } else
//                   // return MessageDisplay(
//                   //   message: 'Something went wrong!',
//                   // );
//                   return Text('hello world');
//                 },
//               ),
//               SizedBox(height: 20),
//               // Bottom half
//               // TriviaControls()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
