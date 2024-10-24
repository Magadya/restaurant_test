import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_test/presentation/presentation/cubit/product/product_state.dart';


import '../../../../domain/usecases/products/get_products.dart';


class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProducts;

  ProductCubit({
    required this.getProducts,
  }) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    final result = await getProducts();
    result.fold(
          (failure) => emit(ProductError(failure.toString())),
          (products) => emit(ProductLoaded(products)),
    );
  }
}