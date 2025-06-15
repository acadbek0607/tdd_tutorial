import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/errors/failures.dart';
import 'package:tdd_tutorial/core/usecases/usecase.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/repos/number_trivia_repo.dart';
import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepo repo;

  GetConcreteNumberTrivia(this.repo);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repo.getConcreteNumberTrivia(params.number);
  }

  // Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
  //   return await repo.getConcreteNumberTrivia(number);
  // }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
