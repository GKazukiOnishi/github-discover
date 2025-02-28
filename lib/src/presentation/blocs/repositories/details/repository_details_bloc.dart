import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_discover/src/domain/entities/repository.dart';
import 'package:github_discover/src/domain/usecases/repository/get_repository_usecase.dart';

part 'repository_details_event.dart';
part 'repository_details_state.dart';

class RepositoryDetailsBloc
    extends Bloc<RepositoryDetailsEvent, RepositoryDetailsState> {
  final GetRepositoryUseCase getRepositoryUseCase;

  RepositoryDetailsBloc({required this.getRepositoryUseCase})
      : super(RepositoryDetailsInitial()) {
    on<RepositoryDetailLoadedEvent>(_onRepositoryDetailLoadedEvent);
  }

  void _onRepositoryDetailLoadedEvent(
    RepositoryDetailLoadedEvent event,
    Emitter emit,
  ) async {
    emit(RepositoryDetailsLoading());

    final result = await getRepositoryUseCase.execute(event.fullName!);
    result.fold(
      (failure) {
        emit(RepositoryDetailsError(
          message: failure.message,
        ));
      },
      (data) {
        emit(RepositoryDetailsSuccess(repository: data));
      },
    );
  }
}
