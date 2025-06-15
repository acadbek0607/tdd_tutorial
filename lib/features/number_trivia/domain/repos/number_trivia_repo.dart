import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/errors/failures.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepo {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
