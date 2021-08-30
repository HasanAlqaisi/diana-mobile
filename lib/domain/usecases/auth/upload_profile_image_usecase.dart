import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/auth/user.dart';
import 'package:diana/domain/repos/auth_repo.dart';

class UploadProfileImageUsecase {
  final AuthRepo? authRepo;

  UploadProfileImageUsecase(this.authRepo);

  Future<Either<Failure, User>> call(File image) {
    return authRepo!.uploadProfileImage(image);
  }
}
