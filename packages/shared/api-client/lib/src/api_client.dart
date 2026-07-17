import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:models/models.dart';

import 'auth_response.dart';
import 'products_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: '')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Service Types
  @GET('/service-types')
  Future<List<ServiceType>> getServiceTypes();

  @GET('/service-types/{id}')
  Future<ServiceType> getServiceType(@Path('id') String id);

  // Services
  @GET('/services')
  Future<List<Service>> getServices(@Query('serviceTypeId') String? serviceTypeId);

  @GET('/services/{id}')
  Future<Service> getService(@Path('id') String id);

  @GET('/services/{id}/price')
  Future<Map<String, dynamic>> calculatePrice(
    @Path('id') String id,
    @Query('area') double? area,
    @Query('extras') String? extras,
  );

  // Categories
  @GET('/categories')
  Future<List<Category>> getCategories(@Query('flat') String? flat);

  @GET('/categories/{id}')
  Future<Category> getCategory(@Path('id') String id);

  // Products
  @GET('/products')
  Future<ProductsResponse> getProducts(
    @Query('sellerId') String? sellerId,
    @Query('categoryId') String? categoryId,
    @Query('search') String? search,
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('sort') String? sort,
  );

  @GET('/products/{id}')
  Future<Product> getProduct(@Path('id') String id);

  @POST('/products')
  Future<Product> createProduct(@Body() Map<String, dynamic> body);

  @PATCH('/products/{id}')
  Future<Product> updateProduct(@Path('id') String id, @Body() Map<String, dynamic> body);

  @DELETE('/products/{id}')
  Future<void> deleteProduct(@Path('id') String id);

  // Seller
  @POST('/seller/profile')
  Future<SellerProfile> createSellerProfile(@Body() Map<String, dynamic> body);

  @GET('/seller/profile')
  Future<SellerProfile> getSellerProfile();

  @PATCH('/seller/profile')
  Future<SellerProfile> updateSellerProfile(@Body() Map<String, dynamic> body);

  @GET('/seller/dashboard')
  Future<Map<String, dynamic>> getSellerDashboard();

  @POST('/seller/kyc')
  Future<KycDocument> submitKyc(@Body() Map<String, dynamic> body);

  @GET('/seller/kyc')
  Future<List<KycDocument>> getKycStatus();

  @POST('/promo-codes/validate')
  Future<Map<String, dynamic>> validatePromoCode(@Body() Map<String, dynamic> body);

  // Auth
  @POST('/auth/register')
  Future<AuthResponse> register(@Body() Map<String, dynamic> body);

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);

  @POST('/auth/refresh')
  Future<AuthResponse> refresh(@Body() Map<String, dynamic> body);

  @POST('/auth/forgot-password')
  Future<Map<String, dynamic>> forgotPassword(@Body() Map<String, dynamic> body);

  @POST('/auth/reset-password')
  Future<Map<String, dynamic>> resetPassword(@Body() Map<String, dynamic> body);

  @POST('/auth/change-password')
  Future<Map<String, dynamic>> changePassword(@Body() Map<String, dynamic> body);

  @POST('/auth/logout')
  Future<Map<String, dynamic>> logout();

  // Users
  @GET('/users/me')
  Future<Profile> getProfile();

  @PATCH('/users/me')
  Future<Profile> updateProfile(@Body() Map<String, dynamic> body);

  @POST('/users/me/avatar')
  Future<Profile> uploadAvatar(@Body() Map<String, dynamic> body);

  // Addresses
  @GET('/addresses')
  Future<List<Address>> getAddresses();

  @GET('/addresses/{id}')
  Future<Address> getAddress(@Path('id') String id);

  @POST('/addresses')
  Future<Address> createAddress(@Body() Map<String, dynamic> body);

  @PATCH('/addresses/{id}')
  Future<Address> updateAddress(@Path('id') String id, @Body() Map<String, dynamic> body);

  @PATCH('/addresses/{id}/default')
  Future<Address> setDefaultAddress(@Path('id') String id);

  @DELETE('/addresses/{id}')
  Future<void> deleteAddress(@Path('id') String id);
}
