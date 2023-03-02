import 'package:chopper/chopper.dart';

part 'ms_graph_api.chopper.dart';

@ChopperApi(baseUrl: '/v1.0')
abstract class MSGraphAPI extends ChopperService {
  
  @Get(path: '/me')
  Future<Response<dynamic>> me();

  static MSGraphAPI create([ChopperClient? client]) => _$MSGraphAPI(client);
}
