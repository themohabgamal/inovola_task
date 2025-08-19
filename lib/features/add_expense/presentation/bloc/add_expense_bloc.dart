import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/services/image_picking_service.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/add_expense_usecase.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final AddExpenseUseCase addExpenseUseCase;
  final ImagePickerService imagePickerService;

  AddExpenseBloc({
    required this.imagePickerService,
    required this.getCategoriesUseCase,
    required this.addExpenseUseCase,
  }) : super(AddExpenseInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<AddExpenseSubmitEvent>(_onAddExpense);
    on<PickReceiptImage>(_onPickReceiptImage);
  }
  Future<void> _onPickReceiptImage(
      PickReceiptImage event, Emitter<AddExpenseState> emit) async {
    final file = await imagePickerService.pickImageFromGallery();
    if (file != null) {
      emit(AddExpenseReceiptPicked(file.name)); // just mocking filename
    }
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    emit(AddExpenseLoading());
    try {
      final categories = await getCategoriesUseCase();
      emit(AddExpenseCategoriesLoaded(categories));
    } catch (e) {
      emit(AddExpenseFailure(e.toString(), []));
    }
  }

  Future<void> _onAddExpense(
    AddExpenseSubmitEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (state is AddExpenseCategoriesLoaded) {
      final currentCategories =
          (state as AddExpenseCategoriesLoaded).categories;
      emit(AddExpenseSubmitting(currentCategories));

      try {
        final success = await addExpenseUseCase(event.expense);
        if (success) {
          emit(AddExpenseSuccess(currentCategories));
        } else {
          emit(AddExpenseFailure('Failed to add expense', currentCategories));
        }
      } catch (e) {
        emit(AddExpenseFailure(e.toString(), currentCategories));
      }
    }
  }
}
