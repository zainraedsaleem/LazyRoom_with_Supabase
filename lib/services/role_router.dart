import 'package:flutter/material.dart';
import 'package:takroom/views/admin_home_view.dart';
import 'package:takroom/views/customer_home_view.dart';
import 'package:takroom/views/login_view.dart';
import 'package:takroom/views/supplier_home_view.dart';

Widget getHomePageByRole(String role) {
  switch (role) {
    case 'customer':
      return const CustomerHomeView();
    case 'admin':
      return const AdminHomeView();
    case 'supplier':
      return const SupplierHomeView();

    default:
      return LoginView();
  }
}
