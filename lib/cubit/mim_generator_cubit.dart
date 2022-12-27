import 'package:algo_test/model/mim_model.dart';
import 'package:algo_test/repository/mim_generator_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'mim_generator_state.dart';

class MimGeneratorCubit extends Cubit<MimGeneratorState> {
  final MimGeneratorRepository mimGeneratorRepository;
  MimGeneratorCubit(this.mimGeneratorRepository) : super(MimGeneratorInitial());

  Future<void> getMim() async {
    try {
      emit(MimGeneratorLoading());
      final mimModel = await mimGeneratorRepository.getMim();
      emit(MimGeneratorLoaded(mimModel));
    } catch (e) {
      emit(MimGeneratorFailed(e.toString()));
    }
  }
}
