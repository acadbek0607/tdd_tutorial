import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_tutorial/core/network/network_info.dart';
import 'package:tdd_tutorial/core/utils/input_converter.dart';
import 'package:tdd_tutorial/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_tutorial/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_tutorial/features/number_trivia/data/repos/number_trivia_repo_impl.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/repos/number_trivia_repo.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(conrete: sl(), random: sl(), inputConverter: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //Repositories
  sl.registerLazySingleton<NumberTriviaRepo>(
    () => NumberTriviaRepoImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkIfno: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(
    () => http.Client(),
  ); // Use http package for network requests
  sl.registerLazySingleton(
    () => InternetConnectionChecker.createInstance(),
  ); // Use http package for network requests
}
