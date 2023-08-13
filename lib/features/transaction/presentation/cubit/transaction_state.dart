// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:pawon_ibu_app/common/data/model/transaction_model.dart';
import 'package:pawon_ibu_app/common/data/model/user_model.dart';

import '../../../../common/data/model/transaction_detail_model.dart';
import '../../../../common/utils/cubit_state.dart';

class TransactionState extends Equatable {
  final CubitState status;
  final String message;
  final int notConfirmedTotal;
  final int orderInProgressTotal;
  final int readyToDeliverTotal;
  final int inDeliverTotal;
  final int totalBill;
  final int orderStatus;
  final UserModel user;
  final List<TransactionModel> orderSection;
  final List<TransactionModel> orders;
  final List<TransactionDetailModel> orderDetail;

  const TransactionState({
    this.status = CubitState.initial,
    this.message = '',
    this.notConfirmedTotal = 0,
    this.orderInProgressTotal = 0,
    this.readyToDeliverTotal = 0,
    this.inDeliverTotal = 0,
    this.totalBill = 0,
    this.orderStatus = 1,
    this.user = const UserModel(),
    this.orderSection = const [],
    this.orders = const [],
    this.orderDetail = const [],
  });

  TransactionState copyWith({
    CubitState? status,
    String? message,
    int? notConfirmedTotal,
    int? orderInProgressTotal,
    int? readyToDeliverTotal,
    int? inDeliverTotal,
    int? totalBill,
    int? orderStatus,
    UserModel? user,
    List<TransactionModel>? orderSection,
    List<TransactionModel>? orders,
    List<TransactionDetailModel>? orderDetail,
  }) {
    return TransactionState(
      status: status ?? this.status,
      message: message ?? this.message,
      notConfirmedTotal: notConfirmedTotal ?? this.notConfirmedTotal,
      orderInProgressTotal: orderInProgressTotal ?? this.orderInProgressTotal,
      readyToDeliverTotal: readyToDeliverTotal ?? this.readyToDeliverTotal,
      inDeliverTotal: inDeliverTotal ?? this.inDeliverTotal,
      totalBill: totalBill ?? this.totalBill,
      orderStatus: orderStatus ?? this.orderStatus,
      user: user ?? this.user,
      orderSection: orderSection ?? this.orderSection,
      orders: orders ?? this.orders,
      orderDetail: orderDetail ?? this.orderDetail,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      message,
      notConfirmedTotal,
      orderInProgressTotal,
      readyToDeliverTotal,
      inDeliverTotal,
      totalBill,
      orderStatus,
      user,
      orderSection,
      orders,
      orderDetail,
    ];
  }
}
