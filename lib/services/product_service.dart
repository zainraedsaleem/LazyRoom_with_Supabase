import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takroom/models/product_model.dart';

class ProductService {
  SupabaseClient _supabase = Supabase.instance.client;

  //getProducts (RPC: يعيد اسم المورد دون كشف جدول users)
  Future<List<Product>> getProducts() async {
    final response = await _supabase.rpc('get_products');
    return (response as List)
        .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  //getSupplierProducts
  Future<List<Product>> getSupplierProducts() async {
    final response = await _supabase
        .from('products')
        .select('''
          id,
          name,
          description,
          image_url,
          price,
          stock,
          category_id,
          supplier_id,
          users(name)
        ''')
        .eq('supplier_id', _supabase.auth.currentUser!.id);
    return (response as List).map((item) => Product.fromJson(item)).toList();
  }

  //getProductsByCategory
  Future<List<Product>> getProductsByCategory({required id}) async {
    final response = await _supabase.rpc(
      'get_products',
      params: {'p_category': id},
    );
    return (response as List)
        .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  //Add New Product
  Future<bool> addProduct({
    required String name,
    String? description,
    required double price,
    required int stock,
    required int category_id,
    required File image,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;
    String? uploadedPath;
    try {
      final bytes = await _compressImage(image);
      if (bytes == null) return false;

      final fileName =
          '${user.id}/${DateTime.now().millisecondsSinceEpoch}.webp';

      await _supabase.storage
          .from('products')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/webp',
              cacheControl: '31536000',
            ),
          );
      uploadedPath = fileName;

      final imageUrl = _supabase.storage
          .from('products')
          .getPublicUrl(fileName);

      await _supabase.from('products').insert({
        'supplier_id': user.id,
        'category_id': category_id,
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'price': price,
        'stock': stock,
      });

      return true;
    } catch (e) {
      debugPrint('addProduct error: $e');
      if (uploadedPath != null) {
        try {
          await _supabase.storage.from('products').remove([uploadedPath]);
        } catch (_) {}
      }
      return false;
    }
  }

  //updateProduct
  Future<bool> updateProduct(
    BuildContext context, {
    required int productId,
    required String name,
    String? description,
    required int price,
    required int stock,
    required int category_id,
    File? newImage,
    String? oldImageUrl,
  }) async {
    // final supabase = Supabase.instance.client;
    final user = _supabase.auth.currentUser;
    if (user == null) return false;
    String? newPath;
    try {
      final data = <String, dynamic>{
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'category_id': category_id,
      };

      if (newImage != null) {
        final bytes = await _compressImage(newImage);
        newPath = '${user.id}/${DateTime.now().millisecondsSinceEpoch}.webp';

        await _supabase.storage
            .from('products')
            .uploadBinary(
              newPath,
              bytes!,
              fileOptions: const FileOptions(
                contentType: 'image/webp',
                cacheControl: '31536000',
              ),
            );

        data['image_url'] = _supabase.storage
            .from('products')
            .getPublicUrl(newPath);
      }

      final updated = await _supabase
          .from('products')
          .update(data)
          .eq('id', productId)
          .eq('supplier_id', user.id)
          .select('id');
      if ((updated as List).isEmpty) {
        throw Exception('Product not found or not yours');
      }

      if (newImage != null && oldImageUrl != null && oldImageUrl.isNotEmpty) {
        final oldPath = _storagePathFromUrl(oldImageUrl);

        if (oldPath != null) {
          try {
            await _supabase.storage.from('products').remove([oldPath]);
          } catch (e) {
            debugPrint('Failed to delete old image: $e');
          }
        }
      }
      return true;
    } catch (e, st) {
      debugPrint('updateProduct error: $e');
      debugPrint('$st');
      if (newPath != null) {
        try {
          await _supabase.storage.from('products').remove([newPath]);
        } catch (_) {}
      }
      return false;
    }
  }

  //deleteProduct
  Future<bool> deleteProduct(BuildContext context, {required productId}) async {
    final supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser?.id;
    if (uid == null) return false;
    try {
      final row = await supabase
          .from('products')
          .select('image_url')
          .eq('id', productId)
          .eq('supplier_id', uid)
          .maybeSingle();
      if (row == null) return false;

      final imageUrl = row['image_url'] as String?;

      final deleted = await supabase
          .from('products')
          .delete()
          .eq('id', productId)
          .eq('supplier_id', uid)
          .select('id');
      if ((deleted as List).isEmpty) return false;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        final path = _storagePathFromUrl(imageUrl);
        if (path != null) {
          try {
            await supabase.storage.from('products').remove([path]);
          } catch (e) {
            debugPrint('Failed to delete image: $e');
          }
        }
      }
      return true;
    } catch (e, st) {
      debugPrint('deleteProduct error: $e');
      debugPrint('$st');
      return false;
    }
  }

  //Compress Image
  Future<Uint8List?> _compressImage(File file) {
    return FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1024,
      minHeight: 1024,
      quality: 80,
      format: CompressFormat.webp,
    );
  }

  //Get Phot storage Path From Url
  static String? _storagePathFromUrl(String url) {
    const marker = '/object/public/products/';
    final i = url.indexOf(marker);
    if (i == -1) return null;
    return Uri.decodeComponent(url.substring(i + marker.length));
  }
}
