# Rewind request's routes

## User requests

#### GET:

1) Get all Users: GET ../api/users

2) Get User by Id: GET ../api/users/{userId}
   
   Returns:
   
   204 No Content (if user was not found)
   
   200 Ok: *User* user

3) Get User Profile Image: GET ../api/users/image/{userId}
   
   Returns:
   
   200 Ok: *byte[]* Image
   
   400 Bad Request: "User not found"

4) Send Verification code on email: GET ../api/users/{email}

#### POST:

1. **Register User**
   
   Route: ../api/register
   
   ```json
   body {
    "username": {username},
    "email": {email},
    "password": {password}
   }
   ```
   
   Returns:
   
   200 Ok: {userId}
   
   400 Bad Request: "User with this email already exists!"

2. **Login User**
   
   Route: ../api/login
   
   ```json
   body {
       "email": {email},
       "password": {password}
   }
   ```

        Returns:

        200 Ok: {userId}

        400 Bad Request: "User not found"

        400 Bad Request: "Incorrect password"

#### PUT:

1. **Change Name**
   
   Route: ../api/change-user/name/{userId}
   
   body { "username": {newName} }
   
   Returns:
   
   200 Ok: "Name changed"
   
   400 Bad Request: "User not found"

2. **Change Email**: 
   
   Route: ../api/change-user/email/{userId}
   
   body { "email": {newEmail} }
   
   Returns:
   
   200 Ok: "Email changed"
   
   400 Bad Request: "User not found"

3. **Change Password**: 
   
   Route: ../api/change-user/password/{userId}
   
   body { "password": {newPassword} }
   
   Returns:
   
   200 Ok: "Password changed"
   
   400 Bad Request: "User not found"

4. **Change Profile Image**: 
   
   Route: ../api/change-user/image/{userId}
   
   body { "media": {newImage - Byte[]} }
   
   Returns:
   
   200 Ok: "Image changed"
   
   400 Bad Request: "User not found"

#### DELETE:

1. **Delete User by Id**
   
   Route: ../api/users/delete/{userId}
   
   Returns:
   
   - 200 Ok: "{userId}"
   
   - 400 Bad Request: "User not found"
