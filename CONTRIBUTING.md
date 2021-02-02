## Contribution

All contributions are very **welcomed!**

And even if you have an idea to improve **Diana** and makes life easier, don't hesitate to do so!

## Setup
- Clone the project
- run (flutter pub get) command
- run (flutter pub run build_runner build) to get auto generated files
- to make the code compile add _constants.dart file to lib/core/constants
- write in that file

```
import 'package:diana/data/remote_models/auth/refresh_info.dart';

const baseUrl = 'WRITE_BASE_URL_VALUE';
const refreshKey = 'REFRESH_KEY';
const tokenKey = 'TOKEN_KEY';
const userIdKey = 'USER_ID_KEY';
String kToken;
String kRefreshToken;
String kUserId;

void updateToken(RefreshInfo info) {
  kToken = info.access;
  kRefreshToken = info.refresh;
}

```

- run the (flutter run) command, that's it!

## Database

This is the way that our database is designed

![Diana db](https://user-images.githubusercontent.com/75932114/105176817-d1bb3280-5b36-11eb-9b13-9a1704f3bf31.png)

## Other links

- [Diana server](https://github.com/softshape-team/diana-server)
