-- Widen users.password so it can hold password_hash() output.
-- Run this BEFORE deploying the password_hash() code.
-- If you use a table_prefix, adjust the table name (e.g. gift_users).
--
-- Existing MD5/SHA1/plaintext passwords keep working: each user's password
-- is transparently re-hashed with password_hash() the next time they log in.
ALTER TABLE users MODIFY `password` varchar(255) NOT NULL default '';
