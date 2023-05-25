import 'package:mysql1/mysql1.dart';
import '../../../shared/util/db.dart';

void main() async {
  // Menjalankan beberapa contoh penggunaan fungsi-fungsi di kelas DB
  try {
    // Membaca data produk
    final products = await DB.select('products');
    print('Data Produk:');
    for (final product in products) {
      print(
          'ID: ${product['id']}, Nama: ${product['product_name']}, Harga: ${product['price']}, Deskripsi: ${product['description']}');
    }
    print('');

    // Menambahkan data produk baru
    final newProduct = {
      'product_name': 'Laptop',
      'price': 1500.0,
      'description': 'Komputer jinjing'
    };
    final insertedId = await DB.insert('products', newProduct);
    print('Produk baru berhasil ditambahkan dengan ID: $insertedId');
    print('');

    // Mengubah harga produk
    final updateValues = {
      'price': 2000.0,
    };
    final updateWhere = 'id = ?';
    final updateWhereArgs = [
      1
    ]; // Ubah ID sesuai dengan produk yang ingin diubah harganya
    final affectedRows = await DB.update('products', updateValues,
        where: updateWhere, whereArgs: updateWhereArgs);
    print('Jumlah baris yang terpengaruh pada operasi update: $affectedRows');
    print('');

    // Menghapus produk
    final deleteWhere = 'id = ?';
    final deleteWhereArgs = [
      2
    ]; // Ubah ID sesuai dengan produk yang ingin dihapus
    final deletedRows = await DB.delete('products',
        where: deleteWhere, whereArgs: deleteWhereArgs);
    print('Jumlah baris yang terpengaruh pada operasi delete: $deletedRows');
    print('');
  } catch (e) {
    print('Terjadi kesalahan: $e');
  }
}
