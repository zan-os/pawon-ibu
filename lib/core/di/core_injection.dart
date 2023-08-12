import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

class CoreInjection {
  CoreInjection() {
    _registerCore();
  }
}

void _registerCore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  sl.registerSingleton(prefs);
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<FocusNode>(() => FocusNode());
}
