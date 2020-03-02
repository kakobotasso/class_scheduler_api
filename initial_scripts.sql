-- App database
CREATE DATABASE class_scheduler;
CREATE USER cs_user WITH createdb;
ALTER USER cs_user WITH password 'password';
GRANT all ON database class_scheduler TO cs_user;

-- Test database
CREATE DATABASE dart_test;
CREATE USER dart WITH createdb;
ALTER USER dart WITH password 'dart';
GRANT all ON database dart_test TO dart;