import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/common/data/model/transaction_model.dart';
import 'package:pawon_ibu_app/features/transaction/presentation/cubit/transaction_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/data/model/transaction_detail_model.dart';
import '../../../../common/data/model/user_model.dart';
import '../../../../common/utils/cubit_state.dart';
import '../../../../common/utils/error_logger.dart';
import '../../../../core/di/core_injection.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(const TransactionState());

  final _supabase = sl<SupabaseClient>();
  final _userId = sl<SharedPreferences>().getInt('user_id');
  final _transactionId =
      sl<SharedPreferences>().getInt('created_transaction_id');

  Future<void> init() async {
    getUserData();
    fetchNotConfirmedOrder();
    fetchInProgressOrder();
    fetchReadyToDeliverOrder();
    fetchInDeliverOrder();
    fetchCompleteOrder();
  }

  void getUserData() async {
    try {
      final response = await _supabase
          .from('user')
          .select('*')
          .match({'id': _userId}).single();

      final UserModel user = UserModel.fromJson(response);

      emit(state.copyWith(user: user, status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  void fetchNotConfirmedOrder() async {
    emit(state.copyWith(status: CubitState.loading));
    try {
      final List response = await _supabase
          .from('transaction')
          .select(
            '*, user:user_id( id, first_name, last_name, address, telepon, lat, long), transaction_detail:id(*), payment_type:payment_id(*)',
          )
          .match({'transaction_status': 1, 'user_id': _userId});

      final List<TransactionModel> transaction =
          response.map((e) => TransactionModel.fromJson(e)).toList();

      emit(state.copyWith(
        notConfirmedTotal: transaction.length,
        status: CubitState.finishLoading,
        orderSection: transaction,
      ));

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  void fetchInProgressOrder() async {
    emit(state.copyWith(status: CubitState.loading));
    try {
      final List response = await _supabase
          .from('transaction')
          .select(
            '*, user:user_id( id, first_name, last_name, address, telepon, lat, long), transaction_detail:id(*), payment_type:payment_id(*)',
          )
          .match({'transaction_status': 2, 'user_id': _userId});

      final List<TransactionModel> transaction =
          response.map((e) => TransactionModel.fromJson(e)).toList();

      emit(state.copyWith(
        orderInProgressTotal: transaction.length,
        status: CubitState.finishLoading,
        orderSection: transaction,
      ));

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  void fetchReadyToDeliverOrder() async {
    emit(state.copyWith(status: CubitState.loading));

    try {
      final List response = await _supabase
          .from('transaction')
          .select(
            '*, user:user_id( id, first_name, last_name, address, telepon, lat, long), transaction_detail:id(*), payment_type:payment_id(*)',
          )
          .match({'transaction_status': 3, 'user_id': _userId});

      final List<TransactionModel> transaction =
          response.map((e) => TransactionModel.fromJson(e)).toList();

      emit(state.copyWith(
        readyToDeliverTotal: transaction.length,
        status: CubitState.finishLoading,
        orderSection: transaction,
      ));

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  void fetchInDeliverOrder() async {
    emit(state.copyWith(status: CubitState.loading));

    try {
      final List response = await _supabase
          .from('transaction')
          .select(
            '*, user:user_id( id, first_name, last_name, address, telepon, lat, long), transaction_detail:id(*), payment_type:payment_id(*)',
          )
          .match({'transaction_status': 4, 'user_id': _userId});

      final List<TransactionModel> transaction =
          response.map((e) => TransactionModel.fromJson(e)).toList();

      emit(state.copyWith(
        inDeliverTotal: transaction.length,
        status: CubitState.finishLoading,
        orderSection: transaction,
      ));

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  void fetchCompleteOrder() async {
    emit(state.copyWith(status: CubitState.loading));
    try {
      final List response = await _supabase
          .from('transaction')
          .select(
            '*, user:user_id( id, first_name, last_name, address, telepon, lat, long), transaction_detail:id(*), payment_type:payment_id(*)',
          )
          .match({'transaction_status': 5, 'user_id': _userId});

      final List<TransactionModel> transaction =
          response.map((e) => TransactionModel.fromJson(e)).toList();

      emit(state.copyWith(
        status: CubitState.finishLoading,
        orders: transaction,
      ));

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  void fetchOrderDetail() async {
    try {
      final List response = await _supabase.from('transaction_detail').select(
        '''*,
            transaction:transaction_id(*, payment_type:payment_id(*)),
            product:product_id (name, image),
            user:user_id(id, first_name, last_name, address, telepon, lat, long)''',
      ).match({'transaction_id': _transactionId, 'user_id': _userId});
      log('ojan ${jsonEncode(response)}');
      final List<TransactionDetailModel> transaction =
          response.map((e) => TransactionDetailModel.fromJson(e)).toList();

      emit(state.copyWith(
        status: CubitState.finishLoading,
        orderDetail: transaction,
        totalBill: transaction.first.transaction?.totalBill,
        orderStatus: transaction.first.transaction?.transactionStatus,
      ));

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  Future<void> confirmOrder({required int expanses}) async {
    try {
      await _supabase.from('transaction').update({
        'transaction_status': 2,
        'received_payment_total': state.totalBill,
        'expenses': expanses
      }).match({'id': _transactionId, 'user_id': _userId});
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  Future<void> completeProcess() async {
    try {
      await _supabase.from('transaction').update({
        'transaction_status': 3,
        'received_payment_total': state.totalBill,
      }).match({'id': _transactionId, 'user_id': _userId});
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  Future<void> deliverOrder() async {
    try {
      await _supabase.from('transaction').update({
        'transaction_status': 4,
        'received_payment_total': state.totalBill,
      }).match({'id': _transactionId, 'user_id': _userId});
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  Future<void> completeOrder() async {
    try {
      await _supabase.from('transaction').update({
        'transaction_status': 5,
        'received_payment_total': state.totalBill,
      }).match({'id': _transactionId, 'user_id': _userId});
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  void reachSeller() async {
    const sellerContact = '6281319754401';
    const messageTemplate = 'Halo, Saya ingin bertanya tentang pesanan saya';
    const androidUrl =
        'whatsapp://send?phone=$sellerContact&text=$messageTemplate';
    const webUrl =
        'https://api.whatsapp.com/send?phone=$sellerContact&text=$messageTemplate';

    try {
      if (kIsWeb) {
        await launchUrl(Uri.parse(webUrl));
      } else if (Platform.isAndroid) {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on PlatformException catch (e, s) {
      errorLogger(e.code, s);
    } catch (e, s) {
      errorLogger(e, s);
    }
  }
}
