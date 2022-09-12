import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concreate_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(NumberTriviaInitial()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      await inputEither.fold(
        (failure) {
          emit(NumberTriviaError(message: _mapFailureToMessage(failure)));
        },
        (integer) async {
          emit(NumberTriviaLoading());
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));

          failureOrTrivia.fold(
              (failure) => emit(
                  NumberTriviaError(message: _mapFailureToMessage(failure))),
              (trivia) => emit(
                    NumberTriviaLoaded(trivia: trivia),
                  ));
        },
      );
    });
    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(NumberTriviaLoading());
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      failureOrTrivia.fold(
          (failure) =>
              emit(NumberTriviaError(message: _mapFailureToMessage(failure))),
          (trivia) => emit(
                NumberTriviaLoaded(trivia: trivia),
              ));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case InvalidInputFailure:
        return INVALID_INPUT_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
