import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

import 'brotli_api.dart';

Future<void> main(List<String> args) async {
  final url = args.isEmpty ? _fallback : args.single;

  final brotliPath = Platform.script.resolve('libbrotli.wasm');
  final moduleData = File(brotliPath.toFilePath()).readAsBytesSync();
  final brotli = Brotli(moduleData);

  final client = _BrotliClient(brotli);
  try {
    final response = await client.get(
      Uri.parse(url),
      headers: {'accept-encoding': 'br'},
    );

    print(response.body.length);
  } finally {
    client.close();
  }
}

const _fallback =
    'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css';

class _BrotliClient extends BaseClient {
  _BrotliClient(this._brotli);

  final Brotli _brotli;
  final _innerClient = IOClient();

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final response = await _innerClient.send(request);

    if (response.headers['content-encoding'] == 'br') {
      final bytes = await response.stream.toBytes();

      final newBytes = _brotli.decompress(bytes, bytes.length * 10);

      return StreamedResponse(
        ByteStream.fromBytes(newBytes),
        response.statusCode,
        request: request,
        headers: response.headers,
        reasonPhrase: response.reasonPhrase,
      );
    }

    return response;
  }

  @override
  void close() {
    _innerClient.close();
  }
}
