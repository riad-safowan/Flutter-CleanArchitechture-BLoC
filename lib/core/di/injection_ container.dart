import 'package:clean_architecture_block/core/utils/input_converter.dart';
import 'package:clean_architecture_block/features/number_trivia/data/repositories/number_trivia_repositoty_impl.dart';
import 'package:clean_architecture_block/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_block/features/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'package:clean_architecture_block/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_block/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import '../../features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //BloC
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));

  //usecases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

   sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //core
  sl.registerLazySingleton(() => InputConverter());
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
