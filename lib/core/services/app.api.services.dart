import 'package:absensi_cifo_v2/core/constants/app.constants.dart';
import 'package:absensi_cifo_v2/core/services/app.network.services.dart';
import 'package:absensi_cifo_v2/core/services/app.storage.services.dart';
import 'package:dio/dio.dart';

class AppApiServices
{
    //   DIO PACKAGES
    final Dio dio = Dio();

    static const String baseUrl = AppConstants.baseUrl;

    //   REQUEST TYPES
    Future<dynamic> post(String endpoint, dynamic requestData) async
    {
        final isConnected = await checkConnection();

        final accessToken = await AppStorageServices().getData("token");

        if (!isConnected)
        {
            throw Exception("No internet connection!");
        }

        try
        {
            Response response;

            if (accessToken == null)
            {
                response = await dio.post(
                    baseUrl + endpoint,
                    data: requestData
                );

                return response;

            }
            else
            {
                final headers = {'Authorization': 'Bearer $accessToken'};

                response = await dio.post(baseUrl + endpoint, data: requestData, options: Options(headers: headers));
                if (response.statusCode == 200 || response.statusCode == 201)
                {
                    return response;
                }
                else
                {
                    throw Exception('Failed to post : ${response.statusCode}');
                }
            }
        }
        catch (e)
        {
            throw Exception('Error in request: $e');
        }
    }

    Future<dynamic> postCDC(String endpoint, dynamic requestData) async
    {
        final isConnected = await checkConnection();

        if (!isConnected)
        {
            throw Exception('No internet connection!');
        }

        try
        {
            Response response;

            response = await dio.post(
                AppConstants.cdcUrl + endpoint,
                data: requestData
            );

            if (response.statusCode == 200 || response.statusCode == 201)
            {
                return response;
            }
            else
            {
                throw Exception('Failed to post : ${response.statusCode}');
            }
        }
        catch (e)
        {
            throw Exception('Error in request: $e');
        }
    }
}
