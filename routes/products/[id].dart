import 'package:dart_frog/dart_frog.dart';
import '../../shared/util/db.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final request = context.request;
  final method = request.method;
  if (method == HttpMethod.put) return putRequest(context, id);
  if (method == HttpMethod.delete) return deleteRequest(context, id);
  return Response.json(body: {
    "message": "Invalid route",
  });
}

Future<Response> putRequest(RequestContext context, String id) async {
  final request = context.request;
  final data = await request.json();
  await DB.update(
    'products',
    data as Map<String, dynamic>,
    where: "id = ?",
    whereArgs: [id],
  );
  return Response.json(
    body: {
      "message": "Success",
    },
  );
}

Future<Response> deleteRequest(RequestContext context, String id) async {
  await DB.delete(
    'products',
    where: "id = ?",
    whereArgs: [id],
  );
  return Response.json(
    body: {
      "message": "Success",
    },
  );
}
