import 'package:dartz/dartz.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../../core/errors/failures.dart';
import '../datasources/local/database_helper.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DatabaseHelper databaseHelper;

  ProductRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('products');

      final products = maps.map((map) => Product(
        id: map['id'],
        name: map['name'],
        price: map['price'],
        imageUrl: map['imageUrl'],
        type: map['type'] == 'pizza' ? ProductType.pizza : ProductType.drink,
        description: map['description'],
      )).toList();

      return Right(products);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}