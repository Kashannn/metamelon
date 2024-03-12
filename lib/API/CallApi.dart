import 'dart:convert';
import 'package:http/http.dart' as http;
class CallApi{

  final String _url = 'https://jsonplaceholder.typicode.com/';


  Future<http.Response> postData(data, apiUrl) async {
    print("URL: $_url$apiUrl"); // Call init method to retrieve the authentication token
    return await http.post(

      Uri.parse(_url + apiUrl),
      body: jsonEncode(data),
      headers: await _setHeader(),
    );
  }

  Future<http.Response> deleteData(apiUrl) async {
    print("URL: $_url$apiUrl");
    return await http.delete(
      Uri.parse(_url + apiUrl),
      headers: await _setHeader(),
    );
  }

  Future<http.Response> getData(String apiUrl) async {

    print("URL: $_url$apiUrl");
    return await http.get(
      Uri.parse(_url + apiUrl),
      headers: await _setHeader(),
    );
  }

  //put method for updating data
  Future<http.Response> putData(data, apiUrl) async {
    return await http.put(
      Uri.parse(_url + apiUrl),
      body: jsonEncode(data),
      headers: await _setHeader(),
    );
  }



  Future<Map<String, String>> _setHeader() async {

    var headers = {
      'Content-type': 'application/vnd.api+json',
      'Accept': 'application/vnd.api+json',
    };


    return headers;
  }
}