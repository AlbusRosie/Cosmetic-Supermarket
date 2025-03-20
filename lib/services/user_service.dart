import 'package:pocketbase/pocketbase.dart';

import '../models/user.dart';
import 'pocketbase_client.dart';

class UserService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel userModel) {
    final avatar = userModel.getStringValue('avatar');
    return pb.files.getUrl(userModel, avatar).toString();
  }

  Future<List<User>> fetchUsers({bool filteredByUser = false}) async {
    final List<User> users = [];
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb!.authStore.record?.id;
      final filter = filteredByUser
          ? "id='$userId' && urole='customer'"
          : "urole='customer'";
      final userModels = await pb.collection('users').getFullList(
            filter: filter,
          );

      for (final userModel in userModels) {
        final userJson = userModel.toJson();
        users.add(User.fromJson({
          ...userJson,
          'avatar': _getFeaturedImageUrl(pb, userModel),
        }));
      }
      print('Fetched ${users.length} customers');
      return users;
    } catch (error) {
      print('🔴🔴🔴 Error fetching users: $error');
      return users;
    }
  }

}
