import 'dart:convert';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Cart>> getCart() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(Cart());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts?${_apiToken}with=food;food.restaurant;extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) {
    return Cart.fromJSON(data);
  });
}

Future<Stream<int>> getCartCount() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(0);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/count?${_apiToken}search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map(
        (data) => Helper.getIntData(data as Map<String, dynamic>),
      );
}

Future<Cart> addCart(Cart cart, bool reset) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Cart();
  }
  Map<String, dynamic> decodedJSON = {};
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String _resetParam = 'reset=${reset ? 1 : 0}';
  cart.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts?$_apiToken&$_resetParam';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  try {
    decodedJSON = json.decode(response.body)['data'] as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(CustomTrace(StackTrace.current, message: e.toString()));
  }
  return Cart.fromJSON(decodedJSON);
}

Future<Cart> updateCart(Cart cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Cart();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  cart.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  return Cart.fromJSON(json.decode(response.body)['data']);
}

Future<bool> removeCart(Cart cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return false;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Helper.getBoolData(json.decode(response.body));
}
