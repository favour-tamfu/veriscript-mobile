import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_providers.dart';

final edgeFunctionCallerProvider = Provider<EdgeFunctionCaller>(
  (ref) => EdgeFunctionCaller(ref.watch(supabaseClientProvider)),
);

class EdgeFunctionCaller {
  EdgeFunctionCaller(this._client);

  final SupabaseClient _client;

  Future<dynamic> invoke(String functionName, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client.functions.invoke(functionName, body: body);
      return response.data;
    } on FunctionException catch (error) {
      throw EdgeFunctionException(
        error.details?.toString() ?? error.reasonPhrase ?? 'Edge function failed.',
      );
    } catch (error) {
      throw EdgeFunctionException(error.toString());
    }
  }
}

class EdgeFunctionException implements Exception {
  EdgeFunctionException(this.message);

  final String message;

  @override
  String toString() => message;
}
