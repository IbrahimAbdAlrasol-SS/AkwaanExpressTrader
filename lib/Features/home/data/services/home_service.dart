import 'dart:async';
import 'package:Tosell/Features/home/data/models/Home.dart';

class HomeService {
  // Simulate API calls with mock data
  
  Future<Home> getInfo() async {
    return await getHomeData();
  }

  Future<Home> getHomeData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return mock home data
    return const Home(
      id: '1',
      name: 'متجر أكوان إكسبريس',
      description: 'متجر إلكتروني متخصص في التجارة',
      totalOrders: 156,
      totalRevenue: 150000.0,
      pendingOrders: 5,
      completedOrders: 45,
    );
  }

  Future<Map<String, dynamic>> getStatistics() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return {
      'totalProfit': 12450.0,
      'totalLoss': 3200.0,
      'totalTransactions': 156,
      'successRate': 78.0,
      'receivables': 200000.0,
      'debts': 50000.0,
    };
  }

  Future<List<Map<String, dynamic>>> getRecentActivities() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return [
      {
        'id': '1',
        'type': 'receipt',
        'description': 'وصل جديد من العميل أحمد',
        'amount': 5000.0,
        'date': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'id': '2',
        'type': 'payment',
        'description': 'دفعة للمورد محمد',
        'amount': -2500.0,
        'date': DateTime.now().subtract(const Duration(hours: 5)),
      },
      {
        'id': '3',
        'type': 'receipt',
        'description': 'وصل من العميل فاطمة',
        'amount': 3200.0,
        'date': DateTime.now().subtract(const Duration(days: 1)),
      },
    ];
  }

  Future<bool> updateHomeData(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Simulate successful update
    return true;
  }
}