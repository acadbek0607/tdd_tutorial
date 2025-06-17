import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_tutorial/core/errors/failures.dart';
import 'package:tdd_tutorial/core/usecases/usecase.dart';

import 'package:tdd_tutorial/core/utils/input_converter.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

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

  NumberTriviaBloc({
    required GetConcreteNumberTrivia conrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  }) : getConcreteNumberTrivia = conrete,
       getRandomNumberTrivia = random,
       super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither = inputConverter.stringToUnsignedInteger(
          event.numberString,
        );

        inputEither.fold(
          (failure) => emit(const Error(INVALID_INPUT_FAILURE_MESSAGE)),
          (integer) async {
            emit(Loading());
            final failureOrTrivia = await getConcreteNumberTrivia(
              Params(integer),
            );
            _eitherLoadedOrErrorState(failureOrTrivia, emit);
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        _eitherLoadedOrErrorState(failureOrTrivia, emit);
      }
    });
  }
}

void _eitherLoadedOrErrorState(
  Either<Failure, NumberTrivia> either,
  Emitter<NumberTriviaState> emit,
) {
  either.fold(
    (failure) => emit(Error(_mapFailureToMessage(failure))),
    (trivia) => emit(Loaded(trivia)),
  );
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure _:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure _:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected error';
  }
}
