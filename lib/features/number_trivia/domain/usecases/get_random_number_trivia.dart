import 'package:tdd_tutorial/core/errors/failures.dart';
import 'package:tdd_tutorial/core/usecases/usecase.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/repos/number_trivia_repo.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepo repo;

  GetRandomNumberTrivia(this.repo);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repo.getRandomNumberTrivia();
  }
}
