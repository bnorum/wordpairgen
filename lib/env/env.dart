
import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: "lib/env/.env")
abstract class Env {
  @EnviedField(varName: 'API_KEY') // the .env variable.
  static String apiKey = _Env.apiKey;
}