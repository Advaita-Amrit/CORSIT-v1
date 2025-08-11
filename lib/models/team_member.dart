import 'dart:io';
import 'package:flutter/material.dart';

class TeamMember {
  String name;
  String role;
  String email;
  IconData icon;
  File? image;

  TeamMember(this.name, this.role, this.email, this.icon, {this.image});
}
